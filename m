From: "NeilBrown" <neilb@suse.de>
Subject: RE: How to un-degrade an array after a totally spurious failure?
Date: Tue, 26 May 2009 20:47:37 +1000 (EST)
Message-ID: <a2ada9611479c051e268a76df8b45b40.squirrel@neil.brown.name>
References: <20090526082555197.DKXE9202@cdptpa-omta04.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090526082555197.DKXE9202@cdptpa-omta04.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Nix' <nix@esperi.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, May 26, 2009 6:25 pm, Leslie Rhorer wrote:
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> owner@vger.kernel.org] On Behalf Of NeilBrown
>> Sent: Wednesday, May 20, 2009 9:49 PM
>> To: Nix
>> Cc: linux-raid@vger.kernel.org
>> Subject: Re: How to un-degrade an array after a totally spurious
>> failure?
>>
>> On Thu, May 21, 2009 9:10 am, Nix wrote:
>>
>> > So, anyone got a command that would help? I'm not even sure if this is
>> > assembly or growth: it doesn't quite fit into either of those
>> > categories. There must be a way to do this, surely?
>>
>> It is neither.  It is management.
>>
>>  mdadm --manage /dev/mdX --remove /dev/sdb6
>>  mdadm --manage /dev/mdX --add /dev/sdb6
>>
>> (The --manage is not actually needed, but it doesn't hurt).
>>
>> NeilBrown
>
> 	I have exactly the same situation, except there are two "failed"
> disks on a RAID5 array.  As for the OP, the "failures" are spurious.
> Running the remove and then the add command puts the disks back in as
> spare
> disks, not live ones, and then the array just sits there, doing nothing.
> I
> tried the trick of doing
>
> echo repair > /sys/block/md0/md/sync_action
>
> but the array still just sits there saying it is "clean, degraded", with 2
> spare and 5 working devices.
>

No such a good option when you have two failures.
If you have two failures you need to stop the array, then assemble
it again using --force.
It is now too late for that:  adding them with "--add" will have erased
the old metadata.

Your only option is to re-create the array.  Make sure you use the
same parameters (e.g. chunk size) as when you first created the array.
You can check the correct parameters by looking at a device with
"--examine".
Also make sure you put the devices in the correct order.

The best thing to do is to try creating the array, using
"--assume-clean" so it won't trigger a resync.
 Then use "fsck", the "mount" to make sure the data is good.
Once you are satisfied that the data is good and that you created
the array with the right parameters, use "echo repair > ...."
to make sure the array really is 'clean'.

I guess I should stop mdadm from trashing the superblock when you
add a spare to an array which has failed....

NeilBrown


