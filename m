From: Phil Genera <pg@fivesevenfive.org>
Subject: Re: Crash during raid6 reshape, now cannot restart?
Date: Fri, 10 Dec 2010 14:11:50 -0800
Message-ID: <AANLkTikSZTahD2teZg7dkDkfrTaHJhjbG4q0W8n40C7o@mail.gmail.com>
References: <AANLkTimk7Ecth7n+qPZ7R-JOAmCmJUJbCTAw3uY8FpPO@mail.gmail.com>
 <20101211074305.5f55c4b4@notabene.brown> <20101211090253.2f2b7a7c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101211090253.2f2b7a7c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 10, 2010 at 14:02, Neil Brown <neilb@suse.de> wrote:
> On Sat, 11 Dec 2010 07:43:05 +1100 Neil Brown <neilb@suse.de> wrote:
>
>> >
>> > raid5: reshape_position too early for auto-recovery - aborting.
>>
>> Something must be going wrong with the math in raid5:
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (mddev->delta_disks < 0
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ? (here_new * mddev->new_chu=
nk_sectors <=3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0here_old * mddev->chu=
nk_sectors)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 : (here_new * mddev->new_chu=
nk_sectors >=3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0here_old * mddev->chu=
nk_sectors)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Reading from the =
same stripe as writing to - bad */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_ERR "rai=
d5: reshape_position too early for "
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"auto=
-recovery - aborting.\n");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>
>> there 'here_new* new_chunk_size' must be over-flowing. =A0So the siz=
e of the
>> array must only just fit into sector_t.
>> On and arm5 you would need to have CONFIG_LBD set - do you know if i=
t is?

Looking at what I think are the relevant kirkwood kernel config, I
only see CONFIG_LBDAF here:
http://merkel.debian.org/~jurij/

Which upon further investigation is the new name of CONFIG_LBD. So, I
believe so.

>> I guess I need to make that code more robust when sector_t doesn't h=
ave lots
>> more bits that the size of the device...
>>
>> If you can compile your own kernel, you should be able to get it to =
work
>> easily. =A0If not ... complain to whoever provided you with a kernel=
=2E

That'd be the nice folks working on debian squeeze.

> No ... I take that back. =A0here_new is the result of dividing the
> reshape_position by chunk_sector times number of disks.
> So multiplying by chunk_sectors again is not going to cause an overfl=
ow.
>
> So I have no idea what if going on here.... maybe a compiler bug?
>
> If you compile your own kernel, I would put some printk's in
> drives/md/raid5.c just before the above code to see what the values o=
f the
> variables are, and to see what the results of the multiplications wil=
l be.

I'm happy to try my own kernel, but first I think I'll try pulling the
disks and putting them on an x86 machine to see if its actually
platform related. If that works, I can keep the broken array around
for a bit to troubleshoot on. Thanks!

--=20
Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
