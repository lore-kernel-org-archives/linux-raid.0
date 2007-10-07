From: Andrew Clayton <andrew@digital-domain.net>
Subject: Re: RAID 5 performance issue.
Date: Sun, 7 Oct 2007 18:22:08 +0100
Message-ID: <20071007182208.2278e742@alpha.digital-domain.net>
References: <20071003105321.06943824@zeus.pccl.info>
	<Pine.LNX.4.64.0710031243080.8612@p34.internal.lan>
	<20071003211910.439ded54@alpha.digital-domain.net>
	<72dbd3150710031336s331782c3yd0ac7ceda4e81774@mail.gmail.com>
	<20071004150831.6edbf926@zeus.pccl.info>
	<Pine.LNX.4.64.0710041009150.8275@p34.internal.lan>
	<Pine.LNX.4.64.0710041009530.8275@p34.internal.lan>
	<20071004154441.31addcfe@zeus.pccl.info>
	<18182.35390.419883.646409@stoffel.org>
	<20071005204207.2d338375@alpha.digital-domain.net>
	<18182.42211.405326.261727@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18182.42211.405326.261727@stoffel.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: John Stoffel <john@stoffel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, David Rees <drees76@gmail.com>, Andrew Clayton <andrew@pccl.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 5 Oct 2007 16:56:03 -0400, John Stoffel wrote:

> Can you start a 'vmstat 1' in one window, then start whatever you do
> to get crappy performance.  That would be interesting to see.

In trying to find something simple that can show the problem I'm
seeing. I think I may have found the culprit.

Just testing on my machine at home, I made this simple program.

/* fslattest.c */

#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <string.h>


int main(int argc, char *argv[])
{
        char file[255];

        if (argc < 2) {
                printf("Usage: fslattest file\n");
                exit(1);
        }

        strncpy(file, argv[1], 254);
        printf("Opening %s\n", file);

        while (1) {
                int testfd = open(file, 
                        O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600);
                close(testfd);
                unlink(file);
                sleep(1);
        }

        exit(0);
}


If I run this program under strace in my home directory (XFS file system
on a (new) disk (no raid involved) all to its own.like

$ strace -T -e open ./fslattest test

It doesn't looks too bad.

open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.005043>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.000212>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.016844>

If I then start up a dd in the same place.

$ dd if=/dev/zero of=bigfile bs=1M count=500

Then I see the problem I'm seeing at work.

open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <2.000348>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <1.594441>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <2.224636>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <1.074615>

Doing the same on my other disk which is Ext3 and contains the root fs,
it doesn't ever stutter

open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.015423>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.000092>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.000093>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.000088>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.000103>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.000096>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.000094>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.000114>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.000091>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.000274>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.000107>


Somewhere in there was the dd, but you can't tell.

I've found if I mount the XFS filesystem with nobarrier, the
latency is reduced to about 0.5 seconds with occasional spikes > 1
second.

When doing this on the raid array.

open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.009164>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.000071>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.002667>

dd kicks in

open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <11.580238>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <3.222294>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.888863>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <4.297978>

dd finishes 

open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.000199>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.013413>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.025134>


I guess I should take this to the XFS folks.

> John


Cheers,

Andrew
