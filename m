From: Sean Fu <fxinrong@gmail.com>
Subject: Re: [PATCH] fs: buffer: Modify alloc_page_buffers.
Date: Thu, 22 Jun 2017 01:07:48 +0800
Message-ID: <20170621170746.GA4355@linux-zmni.DHCP>
References: <1497877296-22441-1-git-send-email-fxinrong@gmail.com>
 <20170619160315.GD10672@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170619160315.GD10672@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: shli@kernel.org, anton@tuxera.com, jack@suse.cz, axboe@fb.com, ebiggers@google.com, rpeterso@redhat.com, bmarzins@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net
List-Id: linux-raid.ids


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 19, 2017 at 05:03:16PM +0100, Al Viro wrote:
> On Mon, Jun 19, 2017 at 09:01:36PM +0800, Sean Fu wrote:
> > Make alloc_page_buffers support circular buffer list and initialise
> > b_state field.
> > Optimize the performance by removing the buffer list traversal to create
> > circular buffer list.
> 
> > -		bh = head = alloc_page_buffers(page, blocksize, 1);
> > +		bh = head = alloc_page_buffers(page, blocksize, 1, 0, 0);
> 
> Frankly, I don't like that change of calling conventions; it's very easy to
> mess the order of arguments when using interfaces like that and it's hell
> to find when trying to debug the resulting mess.
> 
> Do you really get an observable change in performance?  What loads are
> triggering it?
Yes, I have got the performance change with ext3 file system which block
size is 1024 bytes. It has at least %5 performance improvement.

I have found the performance improvements when writting/reading a 800M
size of file on ext3 file system with 1024 block size.
In this case, Each page has four buffer. In other word, the buffer list
has 4 elements.

I have compared the time that the process spent in kernel mode.

Improvements via this patch
Before		After
Write:
0m5.604s	0m4.116s
0m4.408s	0m3.924s
0m4.184s	0m3.708s
0m4.352s	0m3.656s
0m4.380s	0m3.608s
0m4.240s	0m3.612s
0m4.460s	0m3.552s
0m4.072s	0m3.832s
0m4.300s	0m3.736s
0m4.400s	0m3.480s

Read:
0m3.128s	0m3.036s
0m2.976s	0m2.568s
0m3.384s	0m2.544s
0m3.112s	0m2.752s
0m2.924s	0m2.684s
0m3.084s	0m2.856s
0m3.348s	0m2.576s
0m3.000s	0m2.968s
0m3.012s	0m2.560s
0m2.768s	0m2.752s

Reproduce steps:
1 mkfs.ext3 -b 1024 /dev/sdb1
2 ./test_write.sh ./writetest 10

Test shell script:
#!/bin/bash
i=$2;
while test $((i)) -ge 1; do
	mount /dev/sdb1 /mnt/sdb1/
	time $1 -b 800 -o /mnt/sdb1/fileout
	rm /mnt/sdb1/fileout
	sync
	sleep 1
	umount /mnt/sdb1/
	echo "aaa"
	i=$i-1
done


The attachment are the code for writetest and test result.

--gKMricLos+KVdGMg
Content-Type: text/x-c; charset=us-ascii
Content-Disposition: attachment; filename="writetest.c"

/*
 *
 *   Copyright (c) CHANG Industry, Inc., 2004
 *
 *   This program is free software;  you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
 *   the GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program;  if not, write to the Free Software
 *   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

/*
 *  FILE        : writetest.c
 *  DESCRIPTION : The purpose of this test is to verify that writes to
 *                disk occur without corruption.  It writes one 1MB
 *                buffer at a time, where each byte in the buffer is
 *                generated from a random number.  Once done
 *                completed, the file is re-opened, the random number
 *                generator is re-seeded, and the file is verified.
 *
 *  HISTORY:
 *   05/12/2004 : Written by Danny Sung <dannys@changind.com> to
 *                verify integrity of disk writes.
 *
 */

#include <fcntl.h>
#include <getopt.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

//#include "test.h"

#define BLOCKSIZE (1024*1024)
#define FILE_OUT    "fileout"
#define FILE_MODE   0644
#define MAX_FILENAME_LEN 1024

#define tst_resm(prefix, fmt, args...)	\
do {					\
	printf(fmt, ##args);		\
} while (0)

int Verbosity = 0;
int DefaultSeed = 0;
char Filename[MAX_FILENAME_LEN] = FILE_OUT;
off_t NumBlocks = 1;
char *TCID = "writetest";
int TST_TOTAL = 2;

void buf_init(void)
{
	static int seed = 0;
	if (seed == 0)
		seed = DefaultSeed;
	srand(seed);
}

void buf_fill(uint8_t * buf)
{
	int i;
	for (i = 0; i < BLOCKSIZE; i++) {
		*buf = (rand() & 0xff);
		buf++;
	}
}

int write_file(off_t num_blocks, const char *filename)
{
	int fd;
	int ret = 0;
	off_t block;
	uint8_t buf[BLOCKSIZE];

	fd = open(filename, O_RDWR | O_CREAT | O_TRUNC/* | O_LARGEFILE*/,
		  FILE_MODE);
	if (fd < 0) {
		perror(TCID);
		return (-1);
	}
	for (block = 0; block < num_blocks; block++) {
		int rv;
		if (Verbosity > 2)
			tst_resm(TINFO, "Block: %lld/%lld  (%3lld%%)\r",
				 (long long int)block,
				 (long long int)num_blocks,
				 (long long int)(block * 100 / num_blocks));
		buf_fill(buf);
		rv = write(fd, buf, BLOCKSIZE);
		if (rv != BLOCKSIZE) {
			ret = -1;
			break;
		}
	}
	if (Verbosity > 2)
		tst_resm(TINFO, "Block: %lld/%lld  (%3lld%%)\r",
			 (long long int)block, (long long int)num_blocks,
			 (long long int)(block * 100 / num_blocks));
	close(fd);
	return (ret);
}

int read_file(off_t num_blocks, const char *filename)
{
        int fd;
        int ret = 0;
        off_t block;
        uint8_t buf_actual[BLOCKSIZE];
        char buf_read[BLOCKSIZE];

        fd = open(filename, O_RDONLY);
        if (fd < 0) {
                perror(TCID);
                return (-1);
        }
        for (block = 0; block < num_blocks; block++) {
                int rv;
                int n;
                if (Verbosity > 2)
                        tst_resm(TINFO, "Block: %lld/%lld  (%3lld%%)\r",
                                 (long long int)block,
                                 (long long int)num_blocks,
                                 (long long int)(block * 100 / num_blocks));
                buf_fill(buf_actual);
                rv = read(fd, buf_read, BLOCKSIZE);
                if (rv != BLOCKSIZE) {
                        ret = -1;
                        break;
                }
        }
        close(fd);
        if (Verbosity > 2)
                tst_resm(TINFO, "Block: %lld/%lld  (%3lld%%)\r",
                         (long long int)block, (long long int)num_blocks,
                         (long long int)(block * 100 / num_blocks));
        return (ret);
}

int verify_file(off_t num_blocks, const char *filename)
{
	int fd;
	int ret = 0;
	off_t block;
	uint8_t buf_actual[BLOCKSIZE];
	char buf_read[BLOCKSIZE];

	fd = open(filename, O_RDONLY);
	if (fd < 0) {
		perror(TCID);
		return (-1);
	}
	for (block = 0; block < num_blocks; block++) {
		int rv;
		int n;
		if (Verbosity > 2)
			tst_resm(TINFO, "Block: %lld/%lld  (%3lld%%)\r",
				 (long long int)block,
				 (long long int)num_blocks,
				 (long long int)(block * 100 / num_blocks));
		buf_fill(buf_actual);
		rv = read(fd, buf_read, BLOCKSIZE);
		if (rv != BLOCKSIZE) {
			ret = -1;
			break;
		}
		for (n = 0; n < BLOCKSIZE; n++) {
			int ba, br;
			ba = buf_actual[n] & 0xff;
			br = buf_read[n] & 0xff;
			if (ba != br) {
				if (Verbosity > 2)
					tst_resm(TINFO,
						 "Mismatch: block=%lld +%d bytes offset=%lld read: %02xh actual: %02xh\n",
						 (long long int)block, n,
						 (long long
						  int)((block * BLOCKSIZE) + n),
						 br, ba);
				ret++;
			}
		}
	}
	close(fd);
	if (Verbosity > 2)
		tst_resm(TINFO, "Block: %lld/%lld  (%3lld%%)\r",
			 (long long int)block, (long long int)num_blocks,
			 (long long int)(block * 100 / num_blocks));
	return (ret);
}

void usage(void)
{
	printf("%s [-v] [-b blocks] [-s seed] [-o filename]\n", TCID);
	printf("\n"
	       "   -v          - increase verbosity level\n"
	       "   blocks      - number of blocks to write\n"
	       "   seed        - seed to use (0 to use timestamp)\n"
	       "   filename    - name of output file\n");
}

void parse_args(int argc, char **argv)
{
	int c;
	TCID = argv[0];

	while (1) {
		int option_index = 0;
		static struct option long_options[] = {
			{"blocks", 1, 0, 'b'},
			{"out", 1, 0, 'o'},
			{"seed", 1, 0, 's'},
			{"verbose", 0, 0, 'v'},
			{"help", 0, 0, 'h'},
			{0, 0, 0, 0}
		};
		c = getopt_long(argc, argv, "hvb:o:s:", long_options,
				&option_index);
		if (c == -1)
			break;
		switch (c) {
		case 'b':
			NumBlocks = strtoul(optarg, NULL, 0);
			break;
		case 'o':
			strncpy(Filename, optarg, MAX_FILENAME_LEN);
			break;
		case 's':
			DefaultSeed = strtoul(optarg, NULL, 0);
			break;
		case 'v':
			Verbosity++;
			break;
		case 'h':
		default:
			usage();
			exit(-1);
		}
	}
}
/*
void setup()
{
	tst_tmpdir();

}

void cleanup(void)
{
	tst_rmdir();
	tst_exit();
}
*/
int main(int argc, char *argv[])
{
	int rv;

//	setup();

	DefaultSeed = time(NULL);
	parse_args(argc, argv);
	tst_resm(TINFO, "Blocks:       %lld\n", (long long int)NumBlocks);
	tst_resm(TINFO, "Seed:         %d\n", DefaultSeed);
	tst_resm(TINFO, "Output file: '%s'\n", Filename);

	tst_resm(TINFO, "Writing %lld blocks of %d bytes to '%s'\n",
		 (long long int)NumBlocks, BLOCKSIZE, Filename);
	buf_init();

	rv = write_file(NumBlocks, Filename);
	if (rv == 0) {
		tst_resm(TPASS, "Write: Success");
	} else {
		tst_resm(TFAIL, "Write: Failure");
	}
/*
	rv = read_file(NumBlocks, Filename);
        if (rv == 0) {
                tst_resm(TPASS, "Read: Success");
        } else {
                tst_resm(TFAIL, "Read: Failure");
        }
*/
/*
	tst_resm(TINFO, "Verifying %lld blocks in '%s'\n",
		 (long long int)NumBlocks, Filename);
	buf_init();
	rv = verify_file(NumBlocks, Filename);
	if (rv == 0) {
		tst_resm(TPASS, "Verify: Success\n");
	} else {
		tst_resm(TFAIL, "Verify: Failure");
		tst_resm(TINFO, "Total mismatches: %d bytes\n", rv);
	}
	cleanup();
*/
	return 0;
}

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="patched_data.txt"
Content-Transfer-Encoding: 8bit

patched kernel：
============================================================================================================================
linux-g6ih:/home/sean/vfs_test # ./test_write.sh ./writetest 10
Blocks:       800
Seed:         1498036495
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Write: Success
real	0m18.466s
user	0m13.581s
sys	0m4.116s
aaa
Blocks:       800
Seed:         1498036515
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Write: Success
real	0m16.188s
user	0m12.013s
sys	0m3.924s
aaa
Blocks:       800
Seed:         1498036532
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Write: Success
real	0m15.700s
user	0m11.481s
sys	0m3.708s
aaa
Blocks:       800
Seed:         1498036549
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Write: Success
real	0m15.284s
user	0m11.493s
sys	0m3.656s
aaa
Blocks:       800
Seed:         1498036567
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Write: Success
real	0m16.049s
user	0m11.933s
sys	0m3.608s
aaa
Blocks:       800
Seed:         1498036585
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Write: Success
real	0m16.489s
user	0m12.441s
sys	0m3.612s
aaa
Blocks:       800
Seed:         1498036603
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Write: Success
real	0m15.466s
user	0m11.605s
sys	0m3.552s
aaa
Blocks:       800
Seed:         1498036620
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Write: Success
real	0m16.381s
user	0m11.749s
sys	0m3.832s
aaa
Blocks:       800
Seed:         1498036638
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Write: Success
real	0m16.163s
user	0m12.241s
sys	0m3.736s
aaa
Blocks:       800
Seed:         1498036655
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Write: Success
real	0m15.523s
user	0m11.537s
sys	0m3.480s
aaa


linux-g6ih:/home/sean/vfs_test # ./test_write.sh ./readtest 10
Blocks:       800
Seed:         1498036833
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Read: Success
real	0m14.719s
user	0m10.305s
sys	0m3.036s
aaa
Blocks:       800
Seed:         1498036849
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Read: Success
real	0m13.756s
user	0m10.933s
sys	0m2.568s
aaa
Blocks:       800
Seed:         1498036864
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Read: Success
real	0m13.743s
user	0m10.841s
sys	0m2.544s
aaa
Blocks:       800
Seed:         1498036879
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Read: Success
real	0m14.808s
user	0m11.545s
sys	0m2.752s
aaa
Blocks:       800
Seed:         1498036895
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Read: Success
real	0m13.863s
user	0m10.777s
sys	0m2.684s
aaa
Blocks:       800
Seed:         1498036910
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Read: Success
real	0m13.377s
user	0m10.301s
sys	0m2.856s
aaa
Blocks:       800
Seed:         1498036925
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Read: Success
real	0m13.394s
user	0m10.465s
sys	0m2.576s
aaa
Blocks:       800
Seed:         1498036939
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Read: Success
real	0m13.645s
user	0m10.457s
sys	0m2.968s
aaa
Blocks:       800
Seed:         1498036954
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Read: Success
real	0m13.420s
user	0m10.297s
sys	0m2.560s
aaa
Blocks:       800
Seed:         1498036968
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Read: Success
real	0m13.394s
user	0m10.345s
sys	0m2.752s
aaa

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="no_patched_data.txt"

linux-g6ih:/home/sean/vfs_test # ./test_write.sh ./writetest 10
Blocks:       800
Seed:         1498027939
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Write: Success
real	0m19.816s
user	0m10.381s
sys	0m5.604s
aaa
Blocks:       800
Seed:         1498027962
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Write: Success
real	0m16.153s
user	0m11.237s
sys	0m4.408s
aaa
Blocks:       800
Seed:         1498027980
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Write: Success
real	0m16.226s
user	0m11.157s
sys	0m4.184s
aaa
Blocks:       800
Seed:         1498027998
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Write: Success
real	0m17.178s
user	0m10.965s
sys	0m4.352s
aaa
Blocks:       800
Seed:         1498028018
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Write: Success
real	0m16.454s
user	0m11.461s
sys	0m4.380s
aaa
Blocks:       800
Seed:         1498028036
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Write: Success
real	0m16.356s
user	0m11.349s
sys	0m4.240s
aaa
Blocks:       800
Seed:         1498028054
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Write: Success
real	0m16.450s
user	0m10.905s
sys	0m4.460s
aaa
Blocks:       800
Seed:         1498028072
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Write: Success
real	0m15.444s
user	0m10.877s
sys	0m4.072s
aaa
Blocks:       800
Seed:         1498028089
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Write: Success
real	0m15.619s
user	0m10.693s
sys	0m4.300s
aaa
Blocks:       800
Seed:         1498028106
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Write: Success
real	0m16.778s
user	0m11.669s
sys	0m4.400s
aaa


linux-g6ih:/home/sean/vfs_test # ./test_write.sh ./readtest 10
Blocks:       800
Seed:         1498028442
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Read: Success
real	0m15.799s
user	0m11.345s
sys	0m3.128s
aaa
Blocks:       800
Seed:         1498028459
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Read: Success
real	0m14.821s
user	0m11.589s
sys	0m2.976s
aaa
Blocks:       800
Seed:         1498028475
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Read: Success
real	0m15.164s
user	0m11.481s
sys	0m3.384s
aaa
Blocks:       800
Seed:         1498028491
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Read: Success
real	0m15.282s
user	0m11.753s
sys	0m3.112s
aaa
Blocks:       800
Seed:         1498028508
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Read: Success
real	0m15.064s
user	0m11.465s
sys	0m2.924s
aaa
Blocks:       800
Seed:         1498028524
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Read: Success
real	0m15.921s
user	0m12.497s
sys	0m3.084s
aaa
Blocks:       800
Seed:         1498028541
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Read: Success
real	0m15.663s
user	0m11.965s
sys	0m3.348s
aaa
Blocks:       800
Seed:         1498028558
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Read: Success
real	0m14.935s
user	0m11.657s
sys	0m3.000s
aaa
Blocks:       800
Seed:         1498028574
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Read: Success
real	0m15.061s
user	0m11.789s
sys	0m3.012s
aaa
Blocks:       800
Seed:         1498028590
Output file: '/mnt/sdb1/fileout'
Writing 800 blocks of 1048576 bytes to '/mnt/sdb1/fileout'
Read: Success
real	0m14.734s
user	0m11.729s
sys	0m2.768s
aaa

--gKMricLos+KVdGMg--
