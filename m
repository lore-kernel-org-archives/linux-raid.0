From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm: recovering from an aborted reshape op - boot messages
Date: Tue, 15 Feb 2011 10:55:08 +1100
Message-ID: <20110215105508.137097fa@notabene.brown>
References: <396537.54229.qm@web65106.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <396537.54229.qm@web65106.mail.ac2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin Flower <gavinflower@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 14 Feb 2011 14:47:48 -0800 (PST) Gavin Flower <gavinflower@yahoo.com>
wrote:

> Hi Neil,
> 
> I did not notice this before (note: I have poor eyesight, so unless I explicitly look, I may not notice things!). but just before Fedora drops to the shell on a reboot I saw these messages (hand transcribed, so might have the odd transcription error):
> 
> /dev/md1: The filing system size (according to the superblock) is 76799952 blocks
> The physical size of the device is 76799616
> Either the superblock or the partition table is likely to be corrupt!
> 
> /dev/md1: UNEXPECTED INCONSISTENCY: RUN fsck manually
> (i.e. without -a or -p options)
> 
> Note that original size according mdadm was not a multiple of 512KB, so I reshaped it to be the largest multiple or 512KB less than the original size.  So my second attempt to reshape, using the 512 chunk size, started okay.
> 
> Advice appreciated.

Hmmm....

Firstly, the -A and -E output you sent are inconsistent.

The "-A" output reports:

mdadm:/dev/md1 has an active reshape - checking if critical section needs to be restored

For 0.90 metadata (which you are using), that can only be reported if the
minor number is at least 91.  i.e. it has been temporarily set to 0.91.

However the "-E" output show that all devices are "0.90.00", not 0.91.

So those devices cannot possibly produce that -A output.

The devices appear to have all completely transitioned to 512K chunksize....

And the -D output seems to show that the array is fine and working properly.

Secondly, as you say you reshaped the array to make it slightly smaller so it
would be a multiple of 512K.  This is obviously needed to change the chunk
size.

But before you did that - did you resize the filesystem to be only that big?
I suspect not.  So the filesystem thinks that it is bigger than the device.
I don't know how best to fix that.

You could try running 'resize2fs" now (was it ext3? I don't remember).  Or
maybe an 'fsck -f' might fix it.

It might be safest to ask on ext3-users@redhat.com.  Report that you shrunk
your array before shrinking the filesystem and ask what the best remedial
strategy is.

NeilBrown

