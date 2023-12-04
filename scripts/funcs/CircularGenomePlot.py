import matplotlib.pyplot as plt 
import numpy as np

def CircularGenomePlot(genome_one, genome_two, savefig=False, output_filename='CircularGenomePlot.png'):
    
    """
    Creates a circular genome plot comparing two genomes.

    Parameters
    ----------
    genome_one : dict
        A dictionary of chromosome names and their values. i.e. {'chr1': 100, 'chr2': 200}
    genome_two : dict
        A dictionary of chromosome names and their values. i.e. {'chr1': 100, 'chr2': 200}
    savefig : bool
        Whether to save the figure or not.
    output_filename : str
        The name of the output file.

    Returns
    -------
    circular_genome_plot : matplotlib.pyplot
    """

    sorted_chromosomes_genome_one = sorted(genome_one.keys())
    sorted_chromosomes_genome_two = sorted(genome_two.keys())

    values_genome_one = [genome_one[chromosome] for chromosome in sorted_chromosomes_genome_one]
    values_genome_two = [genome_two[chromosome] for chromosome in sorted_chromosomes_genome_two]

    total_value_genome_one = sum(values_genome_one)
    normalized_values_genome_one = [value / total_value_genome_one for value in values_genome_one]
    total_value_genome_two = sum(values_genome_two)
    normalized_values_genome_two = [value / total_value_genome_two for value in values_genome_two]

    theta = np.linspace(0, 2 * np.pi, len(sorted_chromosomes_genome_one), endpoint=False)
    values_genome_one = np.array(normalized_values_genome_one)
    values_genome_two = np.array(normalized_values_genome_two)

    theta = np.concatenate((theta, [theta[0]]))
    values_genome_one = np.concatenate((values_genome_one, [values_genome_one[0]]))
    values_genome_two = np.concatenate((values_genome_two, [values_genome_two[0]]))

    fig, ax = plt.subplots(subplot_kw={'projection': 'polar'})
    ax.plot(theta, values_genome_one, marker='o', label='Genome One Expression')
    ax.plot(theta, values_genome_two, marker='o', label='Genome Two Expression')
    ax.fill_between(theta, 0, values_genome_one, color='skyblue', alpha=0.4)
    ax.fill_between(theta, 0, values_genome_two, color='firebrick', alpha=0.4)

    ax.set_xticks(theta[:-1])
    ax.set_xticklabels(sorted_chromosomes_genome_one)
    ax.set_yticklabels([])

    legend = ax.legend(loc='center left', bbox_to_anchor=(1.1, 0.5))
    ax.grid(True, linestyle='--', alpha=0.7)
    plt.tight_layout(rect=[0, 0, 0.9, 1])

    if savefig:
        plt.savefig(dpi=300, fname=output_filename)
    plt.show()
