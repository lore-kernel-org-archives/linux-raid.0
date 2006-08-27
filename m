From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Interesting RAID checking observations
Date: Sun, 27 Aug 2006 07:18:37 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0608270716410.3175@p34.internal.lan>
References: <20060827064644.26795.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060827064644.26795.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux@horizon.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Second, trying checks on a fast (2.2 GHz AMD64) machine, I'm surprised
> at how slow it is:

The PCI bus is only capable of 133MB/s max.  Unless you have dedicated 
SATA ports, each on its own PCI-e bus, you will not get speeds in excess 
of 133MB/s, 200MB/s+ I have read reports of someone using 4-5 SATA 
controllers (SiI 3112 cards on PCI-e x1 ports) and they got around 200MB/s 
or so on a RAID5, I assume that was read performance.



On Sun, 27 Aug 2006, linux@horizon.com wrote:

> Two discoveries: first, I locked up my machine, and second, it's surprisingly
> slow.
>
> I think the former is pilot error, and not a bug, but after applying
> the raid-1 check patch (cherry-picked from the v2.6.18-rc4-mm3 tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/smurf/linux-trees.git)
> to a couple of machines, I decided to try it out.
>
> This is an older 466 MHz P-II Celeron with 6 drives, and 1 GB of
> each drive mirrored in pairs as swap space.  So I did a quick
>
> # for i in /sys/block/md[567]/md/sync_sction; do echo check > $i ; done
>
> to watch them all proceeding in parallel.
>
> But... I had /proc/sys/dev/raid/speed_limit_max set at 200000.
>
> The machine became quite unresponsive for a minute or two
> as the check proceeded.  Caps lock and console-switching worked,
> as did Alt-SysRq, but I couldn't type a single character at the
> console until the first check ended.
>
> Trying it again, I repeated it a few times, and starting the checks
> one at a time, the machine gets jerky with two checks running,
> and becomes unresponsive with three.
>
> The drives are all PATA, one pair on the motherboard (good ol' 440BX
> chipset), and the others on a pair of Promise PDC20268 PCI cards.
>
> I think this is a "duh! that's why seed_limit_max is there" thing,
> but I didn't expect it to saturate the processor before the drives.
>
>
> Second, trying checks on a fast (2.2 GHz AMD64) machine, I'm surprised
> at how slow it is:
>
> md4 : active raid10 sdf3[4] sde3[3] sdd3[2] sdc3[1] sdb3[0] sda3[5]
>      131837184 blocks 256K chunks 2 near-copies [6/6] [UUUUUU]
>      [==================>..]  resync = 90.5% (119333248/131837184) finish=4.2min speed=48628K/sec
>
> This is 6 ST3400832AS 400 GB SATA drives, each capable of 60 MB/s
> sustained, on Sil3132 PCIe controllers with NCQ enabled.  I measured
>> 300 MB/sec sustained aggregate off a temporary RAID-0 device during
> installation.
>
> RAID-5 is even slower:
> md5 : active raid5 sdf4[5] sde4[4] sdd4[3] sdc4[2] sdb4[1] sda4[0]
>      1719155200 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]
>      [>....................]  resync =  2.4% (8401536/343831040) finish=242.9min speed=23012K/sec
>
>
> To illustrate the hardware's capabilities:
>
> # hdparm --direct -tT /dev/sd[abcdef]3
>
> /dev/sda3:
> Timing O_DIRECT cached reads:   232 MB in  2.01 seconds = 115.37 MB/sec
> Timing O_DIRECT disk reads:  200 MB in  3.01 seconds =  66.48 MB/sec
>
> /dev/sdb3:
> Timing O_DIRECT cached reads:   232 MB in  2.01 seconds = 115.62 MB/sec
> Timing O_DIRECT disk reads:  200 MB in  3.03 seconds =  66.06 MB/sec
>
> /dev/sdc3:
> Timing O_DIRECT cached reads:   240 MB in  2.02 seconds = 118.81 MB/sec
> Timing O_DIRECT disk reads:  196 MB in  3.01 seconds =  65.13 MB/sec
>
> /dev/sdd3:
> Timing O_DIRECT cached reads:   236 MB in  2.01 seconds = 117.47 MB/sec
> Timing O_DIRECT disk reads:  174 MB in  3.00 seconds =  57.98 MB/sec
>
> /dev/sde3:
> Timing O_DIRECT cached reads:   236 MB in  2.02 seconds = 117.04 MB/sec
> Timing O_DIRECT disk reads:  198 MB in  3.03 seconds =  65.38 MB/sec
>
> /dev/sdf3:
> Timing O_DIRECT cached reads:   240 MB in  2.00 seconds = 119.75 MB/sec
> Timing O_DIRECT disk reads:  186 MB in  3.01 seconds =  61.77 MB/sec
>
> Or, more to the point (interleaved output fixed up by hand):
>
> # for i in /dev/sd[abcdef]3; do hdparm --direct -tT $i & done
> [2] 4104 [3] 4105 [4] 4106 [5] 4107 [6] 4108 [7] 4109
> /dev/sda3: /dev/sdb3: /dev/sdc3: /dev/sdd3: /dev/sde3: /dev/sdf3:
> Timing O_DIRECT cached reads:   232 MB in  2.00 seconds = 115.85 MB/sec
> Timing O_DIRECT cached reads:   240 MB in  2.00 seconds = 119.75 MB/sec
> Timing O_DIRECT cached reads:   240 MB in  2.02 seconds = 118.84 MB/sec
> Timing O_DIRECT cached reads:   240 MB in  2.02 seconds = 118.66 MB/sec
> Timing O_DIRECT cached reads:   240 MB in  2.02 seconds = 118.62 MB/sec
> Timing O_DIRECT cached reads:   236 MB in  2.02 seconds = 116.57 MB/sec
> Timing O_DIRECT disk reads:  200 MB in  3.01 seconds =  66.41 MB/sec
> Timing O_DIRECT disk reads:  198 MB in  3.01 seconds =  65.80 MB/sec
> Timing O_DIRECT disk reads:  178 MB in  3.01 seconds =  59.07 MB/sec
> Timing O_DIRECT disk reads:  190 MB in  3.02 seconds =  62.88 MB/sec
> Timing O_DIRECT disk reads:  194 MB in  3.03 seconds =  64.09 MB/sec
> Timing O_DIRECT disk reads:  200 MB in  3.03 seconds =  66.08 MB/sec
> [2]   Done                    hdparm --direct -tT $i
> [3]   Done                    hdparm --direct -tT $i
> [4]   Done                    hdparm --direct -tT $i
> [5]   Done                    hdparm --direct -tT $i
> [6]   Done                    hdparm --direct -tT $i
> [7]-  Done                    hdparm --direct -tT $i
>
> A quick test program emulating RAID-1 (appended) produced:
>
> # ./xor /dev/sdb3 /dev/sdc3
> Read 131072 K in 1944478 usec (69025068/sec)
> Read 131072 K in 1952476 usec (68742318/sec)
> Final sum: 0000000000000000
> XOR time: 77007 usec (1742928928 bytes/sec)
> # ./xor /dev/md4 /dev/md4
> Read 131072 K in 580483 usec (231217327/sec)
> Read 131072 K in 583844 usec (229886284/sec)
> Final sum: 0000000000000000
> XOR time: 76901 usec (1745331374 bytes/sec)
> # ./xor /dev/md5 /dev/md5
> Read 131072 K in 484162 usec (277216568/sec)
> Read 131072 K in 458060 usec (293013421/sec)
> Final sum: 0000000000000000
> XOR time: 76752 usec (1748719616 bytes/sec)
>
> And that's without using prefetch or SSE, so I don't think the processor
> is a bottleneck.  Any ideas why checking is not 3x faster?
>
> === xor.c ===
> #define _GNU_SOURCE	/* For O_DIRECT */
> #include <stdio.h>
> #include <malloc.h>	/* For valloc */
> #include <unistd.h>
> #include <fcntl.h>
> #include <sys/time.h>
>
> #define WORDS (16*1024*1024)
> #define BYTES (WORDS * (unsigned)sizeof(long))
>
> static unsigned __attribute__((pure))
> tv_diff(struct timeval const *start, struct timeval const *stop)
> {
> 	return 1000000u * (stop->tv_sec - start->tv_sec) + stop->tv_usec - start->tv_usec;
> }
>
> int
> main(int argc, char **argv)
> {
> 	int fd1, fd2;
> 	long *p1 = valloc(2 * WORDS * sizeof *p1);
> 	long *p2 = p1 + WORDS;
> 	long sum = 0;
> 	unsigned i;
> 	struct timeval start, stop;
> 	ssize_t ss;
>
> 	if (argc != 3) {
> 		fputs("Expecting 2 arguments\n", stderr);
> 		return 1;
> 	}
> 	fd1 = open(argv[1], O_RDONLY | O_DIRECT);
> 	if (fd1 < 0) {
> 		perror(argv[1]);
> 		return 1;
> 	}
> 	fd2 = open(argv[2], O_RDONLY | O_DIRECT);
> 	if (fd2 < 0) {
> 		perror(argv[2]);
> 		return 1;
> 	}
>
> 	gettimeofday(&start, 0);
> 	ss = read(fd1, p1, BYTES);
> 	if (ss < (ssize_t)BYTES) {
> 		if (ss < 0)
> 			perror(argv[1]);
> 		else
> 			fprintf(stderr, "%s: short read (%zd)\n", argv[1], ss);
> 		return 1;
> 	}
> 	gettimeofday(&stop, 0);
> 	i = tv_diff(&start, &stop);
> 	printf("Read %u K in %u usec (%lu/sec)\n", BYTES/1024, i, 1000000ul*BYTES/i);
>
> 	ss = read(fd2, p2, BYTES);
> 	if (ss < BYTES) {
> 		if (ss < 0)
> 			perror(argv[2]);
> 		else
> 			fprintf(stderr, "%s: short read (%zd)\n", argv[2], ss);
> 		return 1;
> 	}
> 	gettimeofday(&start, 0);
> 	i = tv_diff(&stop, &start);
> 	printf("Read %u K in %u usec (%lu/sec)\n", BYTES/1024, i, 1000000ul*BYTES/i);
>
> 	for (i = 0; i < WORDS; i++)
> 		sum |= p1[i] ^ p2[i];
>
> 	gettimeofday(&stop, 0);
>
> 	printf("Final sum: %016lx\n", sum);
> 	i = tv_diff(&start, &stop);
> 	printf("XOR time: %u usec (%lu bytes/sec)\n", i, 1000000ul * BYTES / i);
> 	return 0;
> }
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
