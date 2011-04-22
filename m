From: David Brown <david.brown@hesbynett.no>
Subject: Re: Server =?UTF-8?B?ZG93bi1mYWls4oCLZWQgUkFJRDUtYXNraW5nIGZvciBz?=
 =?UTF-8?B?b21lIGFzc2lzdGFuY2U=?=
Date: Fri, 22 Apr 2011 13:19:43 +0200
Message-ID: <ioro8f$bmb$1@dough.gmane.org>
References: <BANLkTi=81WTykGQ2TXaf7xGEsL-Gkf+Qrw@mail.gmail.com>	<ioq2b8$3rl$1@dough.gmane.org>	<BANLkTim18Sx6JdZO5PiAqnrakDPzy5PNJQ@mail.gmail.com> <BANLkTimQXUvU68op8C-W4qPUQzBRzqgP+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimQXUvU68op8C-W4qPUQzBRzqgP+A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/04/11 04:32, John Valarti wrote:
> On Thu, Apr 21, 2011 at 1:59 PM, David Brown<david.brown@hesbynett.no>  wrote:
> .
>> My first thought would be to get /all/ the disks, not just the "failed"
>> ones, out of the machine.  You want to make full images of them (with
>> ddrescue or something similar) to files on another disk, and then work with
>> those images.  ..
>> Once you've got some (hopefully most) of your data recovered from the
>> images, buy four /new/ disks to put in the machine, and work on your
>> restore.  You don't want to reuse the failing disks, and probably the other
>> two equally old and worn disks will be high risk too.
>
> OK, I think I understand.
> Does that mean I need to buy 8 disks, all the same size or bigger?
> The originals are 250GB SATA so that should be OK, I guess.
>

The way I would handle this is to get a couple of big disks (2 TB). 
They can be external USB drives if that's the most convenient (I have a 
nice hot-plug USB/eSATA enclosure that I find handy for messing about 
with temporary disks).  Put an ext4 (or xfs if you like) system on these 
disks.

Note that none of this need be done on the original computer - use 
whatever is convenient.  And if you already have lots of temporary disk 
space, you don't need to buy new disks yet.

Make images of your original disks - i.e., copy the whole 250 GB disk 
into a file on your big disk, so that you have four 250 GB files 
"originalA.image", "originalB.image", etc.  You can probably forget 
about the oldest dead disk - if it's been dead since 2009 there is 
little chance of it being useful.

Those "original" files are your safety copies - keep them, so that you 
can always get back to where you started without stressing the original 
disks any more.

Then copy those files to new files "diskA.image", etc.  Attach these to 
loop devices ("losetup /dev/loop1 diskA.image", etc.).  Then use these 
loop devices as devices for re-assembling your raid.  I'm not going to 
make any suggestions for that part - Neil is the expert.

The point is, if you mess up you can simple go back a couple of steps 
and re-copy your "original" image files and try again.  You loose 
nothing but a bit of time.

Once you have a re-assembled raid that looks like it contains your data, 
you can work on the restore process.

Restore is done by buying 4 new disks for the original server, setting 
them up as a new raid5, and copying the data over.  It can be very 
convenient to use something like a system rescue cd during this 
operation, so that you are not trying to run from the disks while doing 
the restore.

Once you are done, you will want to check for missing data or file 
system corruption.


mvh.,

David


> I read some more and found out I should run mdadm --examine.
>
> Should I not be able to just add the one disk partition sdc2 back to the RAID?
>
>

