# Libraries
import re
from Bio.SeqUtils import MeltingTemp as mt
from Bio.Seq import Seq

def get_codons(DNA):
    # Start codon
    start_match = re.search('ATG', DNA)
    if start_match:
        start = (start_match.start(), start_match.end(), DNA[start_match.start():start_match.end()])

    # Stop codon
    stop_match = re.search('TGA|TAA|TAG', DNA)
    if stop_match:
        stop = (stop_match.start(), stop_match.end(), DNA[stop_match.start():stop_match.end()])

    return print(f'Start: {start}, Stop: {stop}')

def get_primers(DNA):
    primer_spot = 66    #Fill with what you want
    primer_length = 20   #Fill with what you want
    primer = ((DNA)[(primer_spot-primer_length) +1 :primer_spot +1]).reverse_complement()
    reverse_primer = primer[::-1].reverse_complement()

    return primer, reverse_primer

def get_gcContent(DNA):
    totalC = DNA.count('C')
    totalG = DNA.count('G')
    gcContent = round(((totalC + totalG) / len(DNA)) * 100, 2)

    return print(f'GC Content percentage: {gcContent}%')

def get_melting_temp(primer, reverse_primer):
    mt_forward = ('%0.2f' % mt.Tm_Wallace(primer))
    mt_reverse = ('%0.2f' % mt.Tm_Wallace(reverse_primer))

    return print(f'Melting Temperature Forward: {mt_forward}. Melting Temperature Reverse: {mt_reverse}.')

def main():
    DNA = input('Insert DNA sequence: ')
    get_codons(DNA)

    DNA = Seq(DNA)

    primer, reverse_primer = get_primers(DNA)
    print(f'Forward primer: {primer}. Reverse primer: {reverse_primer}.')

    get_gcContent(DNA)
    get_melting_temp(primer, reverse_primer)

if __name__ == "__main__":
    main()