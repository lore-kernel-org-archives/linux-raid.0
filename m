From: Tyler <pml@dtbb.net>
Subject: Re: strange raid5
Date: Fri, 22 Jul 2005 23:14:19 -0700
Message-ID: <42E1E03B.6030708@dtbb.net>
References: <1122083913.24620.59.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1122083913.24620.59.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: mingz@ele.uri.edu
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

By my calculations, 1048756 is *not* a multiple of 32768 (32 
Kilobytes).  Did I miscalculate?

Regards,
Tyler.

Ming Zhang wrote:

>i created a 32KB chunk size 3 disk raid5. then write this disk with a
>small code i wrote. i found that even i write it with 1048756 in unit,
>which is multiple of stripe size, it still has a lot of read when seen
>from iostat. 
>
>any idea? thanks!
>
>i attached the code for reference.
>
>[root@bakstor2u root]# cat /proc/mdstat
>Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [raid6]
>[raid10] [faulty]
>md0 : active raid5 sdc[2] sdb[1] sda[0]
>      781422592 blocks level 5, 32k chunk, algorithm 2 [3/3] [UUU]
>
>unused devices: <none>
>[root@bakstor2u root]# ./write /dev/md0 1048576 1000
> 1048576Bytes *     1000 :    34.745MB/s
>
>
>avg-cpu:  %user   %nice    %sys %iowait   %idle
>           0.00    0.00   17.17   82.83    0.00
>
>Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
>hda               0.00         0.00         0.00          0          0
>hdc               0.00         0.00         0.00          0          0
>md0            8791.92         0.00     70335.35          0      69632
>sda             605.05       387.88     35143.43        384      34792
>sdb             611.11       323.23     35143.43        320      34792
>sdc             602.02       387.88     35143.43        384      34792
>sdd               0.00         0.00         0.00          0          0
>sde               0.00         0.00         0.00          0          0
>sdf               0.00         0.00         0.00          0          0
>sdg               0.00         0.00         0.00          0          0
>sdh               0.00         0.00         0.00          0          0
>
>
>  
>
>------------------------------------------------------------------------
>
>/*
> * I need a small program to write in various mode.
> */
>#include <stdio.h>
>#include <stdlib.h>
>#include <sys/types.h>
>#include <sys/stat.h>
>#include <sys/time.h>
>#include <fcntl.h>
>
>int main(int argc, char *argv[])
>{
>	int size, cnt;
>	char *buf;
>	char *fn;
>	int fid, i;
>	struct timeval tv1, tv2, ttv1, ttv2;
>	double x;
>	int sync = 1;
>	int timing = 0;
>	unsigned long *t;
>
>	if (argc < 4) {
>		printf("%s <fn> <strip size> <strip count> [s/a [t]]\n", argv[0]);
>		exit(1);
>	}
>	fn = argv[1];
>	size = atoi(argv[2]);
>	cnt = atoi(argv[3]);
>	if ((argc >=5) && (argv[4][0] == 'a'))
>		sync = 0;
>	if ((argc >=6) && (argv[5][0] == 't'))
>		timing = 1;
>	if (timing) {
>		t = (unsigned long *)malloc(sizeof(double) * cnt);
>		if (!t) {
>			printf("fail to get mem for t\n");
>			exit(1);
>		}
>	}
>	buf = malloc(size * sizeof(char));
>	if (!buf) {
>		printf("fail to get memory\n");
>		exit(1);
>	}
>	fid = open(fn, O_CREAT|O_WRONLY|(sync ? O_SYNC : 0), S_IRWXU);
>	if (fid == -1) {
>		printf("open file fail\n");
>		exit(1);
>	}
>	gettimeofday(&tv1, NULL);
>	for (i = 0; i < cnt; i++) {
>		if (timing) {
>			gettimeofday(&ttv1, NULL);
>			write(fid, buf, size);
>			gettimeofday(&ttv2, NULL);
>			t[i] = (ttv2.tv_sec - ttv1.tv_sec) * 1000000 + ttv2.tv_usec - ttv1.tv_usec;
>		} else
>			write(fid, buf, size);
>	}
>	close(fid);
>	gettimeofday(&tv2, NULL);
>	x = (tv2.tv_sec - tv1.tv_sec) + ((double)(tv2.tv_usec - tv1.tv_usec)) 
>		* 0.000001;
>	x = ((double)(size * cnt) / 1048576.0) / x;
>	printf("%8dBytes * %8d :%10.3fMB/s\n", size, cnt, x);
>	if (timing) {
>		for (i = 0; i < cnt; i++) {
>			printf("%8ld", t[i]);
>			if (!(i % 10))
>				printf("\n");
>		}
>		printf("\n");
>	}
>}
>
>  
>
>------------------------------------------------------------------------
>
>No virus found in this incoming message.
>Checked by AVG Anti-Virus.
>Version: 7.0.323 / Virus Database: 267.9.2/55 - Release Date: 7/21/2005
>  
>
