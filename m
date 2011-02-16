From: Phil Turmel <philip@turmel.org>
Subject: Re: Linux software RAID assistance
Date: Wed, 16 Feb 2011 18:39:02 -0500
Message-ID: <4D5C6016.6060809@turmel.org>
References: <4D540F6C.6050904@gmail.com> <20110215155315.55d35b8e@notabene.brown> <4D5A92F3.1090004@turmel.org> <4D5BD678.2050200@gmail.com> <4D5BE119.7000804@turmel.org> <4D5C0E17.3060306@gmail.com> <4D5C140F.9010301@turmel.org> <4D5C1508.3040308@gmail.com> <4D5C15D3.1070608@turmel.org> <4D5C167C.7000101@turmel.org> <4D5C1CF8.1020507@gmail.com> <4D5C1E0B.9060300@turmel.org> <4D5C2061.4060106@gmail.com> <4D5C2143.3000907@turmel.org> <4D5C2260.3020800@gmail.com> <4D5C273E.7020609@turmel.org> <4D5C4176.80604@gmail.com> <4D5C4204.5020106@turmel.org> <1377706586882297883@unknownmsgid>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1377706586882297883@unknownmsgid>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Mcnair <simonmcnair@gmail.com>
Cc: NeilBrown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/16/2011 05:44 PM, Simon Mcnair wrote:
> I just went to bed and one last question popped in to my mind. Since
> there is a fair timezone gap I thought I'd be presumptuous and ask it
> in the hope I can turn it around a bit quicker in the morning.
> 
> My suspicion is that once I have 5 formatted 2tb drives I may be lucky
> to get 10x 1tb dd images on to it. Can I feed the dd process in to
> tar, bzip2, zip or something else which will give me enough space to
> fit the images on ?
> 
> Will I get more usable space from 5x2tb partitions or from 1xspanned
> volume ? (the thecus pretty much only allows you to create raid
> volumes so a jbod needs to be 5x1tb arrays or 1 spanned volume or
> stripe).

I'd use one spanned volume, and gzip.  I'd simultaneously generate an md5sum while streaming to your thecus.  A script like so:

#! /bin/bash
#
function usage() {
	printf "Usage:\n\t%s devname\n\n" "`basename \"$0\"`"
	printf "'devname' must be a relative path in /dev/ to the desired block device.\n"
	exit 1
}

# Verify the supplied name is a device
test -b "/dev/$1" || usage

# Convert path separators and spaces into dashes
outfile="`echo \"$1\" |sed -r -e 's:[ /]+:-:g'`"

# Create a side-stream for computing the MD5 of the data read
fifo=`mktemp -u`
mkfifo $fifo || exit
md5sum -b <$fifo >/mnt/thecus/$outfile.md5 &

# Read the device and compress it
dd if="/dev/$1" bs=1M | tee 2>$fifo | gzip >/mnt/thecus/$outfile.gz

# Wait for the background task to close
wait
