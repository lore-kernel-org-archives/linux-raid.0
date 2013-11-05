From: Kevin Wilson <kevin@digitalarchitects.co.za>
Subject: Re: Seagate black armour recovery
Date: Tue, 5 Nov 2013 21:39:39 +0200
Message-ID: <CAHwiqHsCOzUgktC7DGMXELE0P8kFXbNBji6na0oXfdEWzY4ijg@mail.gmail.com>
References: <CAHwiqHszJWNRZqWuarzJZO8cYqQitUoJ+SeLUco64Po=FA3doQ@mail.gmail.com>
	<52781F71.4060105@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52781F71.4060105@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org, Morne Botha <bothamb@gmail.com>
List-Id: linux-raid.ids

Hi Phil,
Thanks for the quick reply. I should have, as you correctly stated,
included the result from trying to force assemble.
mdadm: looking for devices for /dev/md3
mdadm: /dev/sda4 is identified as a member of /dev/md3, slot 0.
mdadm: /dev/sdb4 is identified as a member of /dev/md3, slot 1.
mdadm: /dev/sdc4 is identified as a member of /dev/md3, slot 2.
mdadm: ignoring /dev/sdb4 as it reports /dev/sda4 as failed
mdadm: ignoring /dev/sdc4 as it reports /dev/sda4 as failed
mdadm: no uptodate device for slot 1 of /dev/md3
mdadm: no uptodate device for slot 2 of /dev/md3
mdadm: no uptodate device for slot 3 of /dev/md3
mdadm: added /dev/sda4 to /dev/md3 as 0
mdadm: /dev/md3 assembled from 1 drive - not enough to start the array.

I was then trying to edit the Array status in sdb4 and sdc4 due to the
two lines ignoring /dev/sd[x]4 as it reports...
The man pages suggest using the --update=summaries with a list of the
devices, however I get an error that states that this is not valid for
1.X superblock versions.

At this point we found only the two options I mentioned, and we
decided to climb the mountain and talk to the oracle. Is there another
way to get the other two drives back into the array?

regards,

Kevin

On 5 November 2013 00:28, Phil Turmel <philip@turmel.org> wrote:
> Hi Kevin,
>
> On 11/04/2013 08:51 AM, Kevin Wilson wrote:
>> Good day All,
>
> [snip /]
>
> Good report, BTW.
>
>> 1. Hexedit the drive status information in the superblocks and set it
>> to what we require to assemble
>
> You would have to be very brave to try that, and very confident that you
> complete understood the on-disk raid metadata.
>
>> 2. Run the create option of mdadm with precisely the original
>> configuration of the pack to overwrite the superblock information
>
> This is a valid option, but should always be the *last* resort.
>
> Your research missed the recommended *first* option:
>
> mdadm --assemble --force ....
>
> [snip /]
>
>> Mdadm examine for each drive:
>> /dev/sda4:
>
>>          Events : 18538
>>    Device Role : Active device 0
>>    Array State : AAA. ('A' == active, '.' == missing)
>
>> /dev/sdb4:
>>          Events : 18538
>>    Device Role : Active device 1
>>    Array State : .AA. ('A' == active, '.' == missing)
>
>> /dev/sdc4:
>>          Events : 18538
>>    Device Role : Active device 2
>>    Array State : ..A. ('A' == active, '.' == missing)
>
>> /dev/sdd4 is the faulty drive that now shows up as 4GB.
>
> Check /proc/mdstat and then use mdadm --stop to make sure any partial
> assembly of these devices is gone.  Then
>
> mdadm -Afv /dev/md3 /dev/sd[abc]4
>
> Save the output so you can report it to this list if it fails.  You
> should end up with the array running in degraded mode.
>
> Use fsck as needed to deal with the detritus from the power losses, then
> make your backups.
>
> HTH,
>
> Phil
>
