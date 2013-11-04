From: Phil Turmel <philip@turmel.org>
Subject: Re: Seagate black armour recovery
Date: Mon, 04 Nov 2013 17:28:01 -0500
Message-ID: <52781F71.4060105@turmel.org>
References: <CAHwiqHszJWNRZqWuarzJZO8cYqQitUoJ+SeLUco64Po=FA3doQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHwiqHszJWNRZqWuarzJZO8cYqQitUoJ+SeLUco64Po=FA3doQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kevin Wilson <kevin@digitalarchitects.co.za>, linux-raid@vger.kernel.org, Morne Botha <bothamb@gmail.com>
List-Id: linux-raid.ids

Hi Kevin,

On 11/04/2013 08:51 AM, Kevin Wilson wrote:
> Good day All,

[snip /]

Good report, BTW.

> 1. Hexedit the drive status information in the superblocks and set it
> to what we require to assemble

You would have to be very brave to try that, and very confident that you
complete understood the on-disk raid metadata.

> 2. Run the create option of mdadm with precisely the original
> configuration of the pack to overwrite the superblock information

This is a valid option, but should always be the *last* resort.

Your research missed the recommended *first* option:

mdadm --assemble --force ....

[snip /]

> Mdadm examine for each drive:
> /dev/sda4:

>          Events : 18538
>    Device Role : Active device 0
>    Array State : AAA. ('A' == active, '.' == missing)

> /dev/sdb4:
>          Events : 18538
>    Device Role : Active device 1
>    Array State : .AA. ('A' == active, '.' == missing)

> /dev/sdc4:
>          Events : 18538
>    Device Role : Active device 2
>    Array State : ..A. ('A' == active, '.' == missing)

> /dev/sdd4 is the faulty drive that now shows up as 4GB.

Check /proc/mdstat and then use mdadm --stop to make sure any partial
assembly of these devices is gone.  Then

mdadm -Afv /dev/md3 /dev/sd[abc]4

Save the output so you can report it to this list if it fails.  You
should end up with the array running in degraded mode.

Use fsck as needed to deal with the detritus from the power losses, then
make your backups.

HTH,

Phil

