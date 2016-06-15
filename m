From: Benjamin ESTRABAUD <ben.estrabaud@mpstor.com>
Subject: Re: Failure propagation of concatenated raids ?
Date: Wed, 15 Jun 2016 15:45:56 +0100
Message-ID: <57616A24.6010808@mpstor.com>
References: <CAAkR8+s1=P5+4w0JBLs71DFtqQiD+x4mssjvL4utmb0HGOfLEg@mail.gmail.com> <22368.45414.256389.605050@quad.stoffel.home> <CAAkR8+vfXJOtYUBvkZXxQhXwh-e2t6yGuarLW4MGS8B+YKtUZg@mail.gmail.com> <57612012.9080902@mpstor.com> <CAAkR8+tkvwZneqz2XpwMEqKCXZk=HERXPu9XC0pNX0OZ-AQ8ZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAkR8+tkvwZneqz2XpwMEqKCXZk=HERXPu9XC0pNX0OZ-AQ8ZA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nicolas Noble <nicolas@nobis-crew.org>
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15/06/16 10:49, Nicolas Noble wrote:
>> I
>> think in your case you're better off stopping an array that has less than
>> parity drives than it should, either using a udev rule or using mdadm
>> --monitor.
>
> I actually have been unsuccessful in these attempts so far. What
> happens is that you very quickly get processes that get indefinitely
> stuck (indefinitely as in 'waiting on a very very long kernel
> timeout') trying to write something, so that the ext4fs layer becomes
> unresponsive on these threads, or take a very long time. Killing the
> processes takes a very long time because they are stuck in a kernel
> operation. And if potentially more processes can spawn back up, the
> automated script starts an interesting game of whack-a-mole in order
> to unmount the filesystem.
>
> And you can't stop the underlying arrays without first stopping the
> whole chain (umount, stop the lvm volume, etc...), otherwise you
> simply get "device is busy" errors, hence the whack-a-mole process
> killing. The only working method I've managed to successfully
> implement is to programatically loop over the list of all the drives
> involved in the filesystem, on all the raids involved, and flag all of
> them as failed drives. This way, you get to really put "emergency
> brakes" on. I find that to be a very, very scary method however.
>
I understand your concern, but I remember a thread where it was 
explained that a RAID0 or linear one basically behaves like a hard drive 
would: since there is no parity and the data is distributed, if say half 
of the devices of the RAID0 are unavailable the LBAs on the other half 
of that RAID will work fine, like if you had a SSD with half of its 
cells broken. So your issue seems to be more related with dealing with 
IO errors than anything. I would imagine that if the filesystem's 
superblock was to become unread/writeable (if it was on the missing 
RAID) then the filesystem would "fail" (be remounted as readonly). Other 
than that there's not much to be done apart from instructing your 
program to stop the IOs and/or fiddling with timeouts to speed up the 
failure of the process.

The "emergency brake" as you put it would work similarly to a RAID5 
losing more than it can: the array will error every write sent to it. 
Alternatively you could disconnect the drives from Linux using the 
"delete" sysfs property. If you use a journalled filesystem you 
shouldn't lose any data over any of this anyways, so that seems safe.

HTH,

Regards,
Ben.
