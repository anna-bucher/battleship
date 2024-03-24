import assert from 'assert'
import { WitnessTester } from 'circomkit'
import { skip } from 'node:test'
import { circomkit } from './common'

const GRID_SIZE = 3
const ENCODING_LENGTH = GRID_SIZE * GRID_SIZE

interface Vessel3 {
  v: number
  po: number
  pv: number
}

let vmap = ([v, po, pv]: number[]) => ({
  v,
  po,
  pv,
})

const valid_vessels: Vessel3[] = [
  [0b000000111, 0, 0],
  [0b000111000, 1, 0],
  [0b111000000, 2, 0],
  [0b001001001, 0, 1],
  [0b010010010, 1, 1],
  [0b100100100, 2, 1],
].map(vmap)

const invalid_vessels: Vessel3[] = [
  [0b000100111, 0, 0],
  [0b000000011, 0, 0],
  [0b100000011, 0, 0],
  [0b1000000000, 0, 0],
  [0b000000000, 2, 1],
  [0b000000000, 3, 1],
].map(vmap)

describe('Vessel3', () => {
  const N = 32
  let circuit: WitnessTester<['v', 'po', 'pv']>

  before(async () => {
    circuit = await circomkit.WitnessTester(`vessel3`, {
      file: 'vessel3',
      template: 'Vessel3',
      params: [],
    })
  })

  skip('should have correct number of constraints', async () => {
    assert.fail('constraint count not working')
    // await circuit.expectConstraintCount(0)
  })

  /*
  it('should not compute with negative base', async () => {
    await circuit.expectConstraintCount(N - 1)
  })

  it('should not compute with negative power', () =>
    circuit.expectFail({ base: 2, power: -1 }))
    */

  valid_vessels.forEach(({ v, po, pv }) => {
    it(`should validate ${pv === 1 ? 'vertical' : 'horizontal'} vessel ${v
      .toString(2)
      .padStart(ENCODING_LENGTH, '0')} with offset ${po}`, () =>
      circuit.expectPass({ v, po, pv }))
  })

  invalid_vessels.forEach(({ v, po, pv }) => {
    it(`should   reject ${pv === 1 ? 'vertical' : 'horizontal'} vessel ${v
      .toString(2)
      .padStart(ENCODING_LENGTH, '0')} with offset ${po}`, () =>
      circuit.expectFail({ v, po, pv }))
  })
})
