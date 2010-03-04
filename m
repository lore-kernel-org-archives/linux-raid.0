From: Alex Boag-Munroe <boagenator@gmail.com>
Subject: Re: I am an idiot (power failure during chunk resize, no backup file)
Date: Thu, 4 Mar 2010 12:37:54 +0000
Message-ID: <68c4f7e31003040437u233f8eb6q6d7351dba50578be@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4 March 2010 12:25, Asdo <asdo@shiftmail.org> wrote:
> Alex Boag-Munroe wrote:
>>
>> Hi guys...
>>
>> Yes I am an idiot. =A0I was changing the chunk size of my RAID5 arra=
y
>> last night from 64kb to 256kb and left it running overnight. =A0Duri=
ng
>> the night we had a power outage.
>>
>> This is where the idiot part comes in. =A0The backup file is on a
>> filesystem that's part of the RAID5 array, so obviously I am unable =
to
>> start it. =A0I completely forgot the filesystem I specified for
>> --backup-file was part of the same array.
>>
>> Once you're all done pointing and laughing, can you let me know if I
>> am totally screwed? =A0I've a lot of data here that I -really- don't
>> want to lose...
>>
>> Please help..
>>
>> Idiot.
>>
>
> Firstly I will say that I have never faced this situation, so please =
wait
> for someone more knowledgeable to reply before trying.
>
> Supposing the resync cannot be continued after a power failure (which=
 I am
> not sure)...
>
> My idea is that the reshape progresses linearly so one of the two
> filesystems (either the original one or backup) should be accessible.=
 If the
> power failed when the reshape was within the first filesystem, the se=
cond
> filesystem should be somehow accessible, if it failed when the reshap=
e was
> within the second filesystem, the first filesystem should be somehow
> accessible.
>
> In this situation I guess you need to go to the hard route: you will
> probably need to recreate the array with all the drives specified exa=
ctly in
> the same order, using all the original options (you can get info from=
 every
> drive with mdadm --examine /dev/sdXY), and the chunksize either set a=
t 64k
> or at 256k (you try both), and specifying --assume-clean so that it d=
oes not
> start to resync, and then set it --readonly before doing anything els=
e. Then
> you will probably be able to do some experiments try mounting one of =
the two
> filesystems.
>
> Thinking again, I guess there is a situation which will prevent you t=
o see
> both filesystems... this is the case if 64kb prevents you to see the =
good
> filesystem and 256k prevents you to see the LVM metadata :-( You use =
LVM
> right? In this case you might need to "find" your filesystem by mount=
ing the
> device with progressively increasing offsets from the beginning, with=
out the
> help of LVM. And this will work only if your good partition in LVM wa=
s
> contiguous (LVM allows holes).
>
> Anyway, wait other replies.
>
> Good luck
>
> Asdo
>
>
>

Hi Asdo.

Yes I am using LVM.  I'm not entirely sure how to go about messing
with the mounting as you describe, I've never had to do it.  Is this
with the mount command?  I do keep getting an error from lvm,
"incorrect metadata area header checksum", with both chunk=3D64 and
chunk=3D256 during the recreate.

Thank you for your reply.

--=20
Alex Boag-Munroe

Lack of planning on your part does not constitute an emergency on mine.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
