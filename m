From: Tim Bostrom <tbostrom@gmail.com>
Subject: Re: RAID 5 array recovery - two drives errors in external enclosure
Date: Fri, 18 Sep 2009 16:30:46 -0700
Message-ID: <2267211f0909181630r33fcdbe5hb0d158b9bf12924b@mail.gmail.com>
References: <2267211f0909171342g6ebf68a2y393daa587e59c714@mail.gmail.com>
	<0F9F69CA6B3942B1A44BC0B2D00AE139@m5> <2267211f0909172119w6de04e46m5fcfc5e6d35c0382@mail.gmail.com>
	<20090918080706.GB22909@cthulhu.home.robinhill.me.uk> <2267211f0909180827jbfa57acqadd308b4b889058c@mail.gmail.com>
	<6b696870909180910q67d8166ay7796321b8cd35809@mail.gmail.com>
	<2267211f0909180912p745e4ea0idb5659cb54a6adce@mail.gmail.com>
	<6b696870909180923m35f29fa2l857b6f6402eb20be@mail.gmail.com>
	<2267211f0909181041o29d6f5eft1e260696c6ab9c57@mail.gmail.com>
	<6b696870909181317x777e3c5dsdcf0e7709f9c4979@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6b696870909181317x777e3c5dsdcf0e7709f9c4979@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy Watkins <guy@watkins-home.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

THANK YOU!

To all of you who helped with advice.  I finally waded through 70MB of
log files from the last 6 months on my server and finally figured out
a way to get the correct order.  I had a few logs of 'fdisk -l" which
contained the Disk Identifier.  I matched that up against where I had
the drives in the enclosure and the ata.#'s.   I came up with a short
list of drive letter ordering and just kept trying them with four
drives at a time moving the _missing_ drive around.  Finally, it came
up.

I'm now up with four drives and RO filesystem.  I'm going to try and
backup as much as possible off-disk.  Then I'm thinking that I need to
add the "missing" drive back in and re-build.

Correct?

Thank you again.

Tim

On Fri, Sep 18, 2009 at 1:17 PM, Guy Watkins <guy@watkins-home.com> wro=
te:
> When you did the create, it trashed 1 drive.=A0 I don't know which on=
e.=A0 As
> long as you don't use that drive, your data should still be there.=A0=
 By
> "trashed" I mean that it reconstructed the data on that drive, but th=
e data
> was not correct.=A0 As long as you aways have 1 drive missing when do=
ing the
> create, md will not write to the user area of the disks.=A0 Anyway, I=
 think
> someone else indicated which drive that was, but maybe you don't real=
ly
> know.=A0 If that is the case, you must try all 5 drives in 4 of the 5=
 slots!
> I think that would be 6*5*4*3*2 or 720 permutations.=A0 Do you want a=
 new
> list?=A0 :)
-snip-

>
> On Fri, Sep 18, 2009 at 1:41 PM, Tim Bostrom <tbostrom@gmail.com> wro=
te:
>>
>> I had log output from my array before it started exhibiting issues a=
nd
>> dropping off drives in the external enclosure. =A0It said 256k in my=
 old
>> mdadm -E output.
>>
>> I accidentally did a re-create of 5 drives for a few seconds with 64=
k
>> chunk size, but then stopped it after it wouldn't mount.
>>
>> i'm hoping I didn't completely destroy this thing. =A0I had a lot of
>> data on there.
>>
>>
>> -Tim
>>
>> On Fri, Sep 18, 2009 at 9:23 AM, Guy Watkins <guy@watkins-home.com> =
wrote:
>> > No problem.=A0 Hopefully you can modify the script I sent and make=
 it
>> > generate
>> > the mdadm commands that you need.=A0 I assumed you could anyway.=A0=
 If you
>> > need,
>> > I can make the changes for you.
>> >
>> > I forgot to ask.=A0 How do you know the correct chunk size?
>> >
>> >
>> >
>> > On Fri, Sep 18, 2009 at 12:12 PM, Tim Bostrom <tbostrom@gmail.com>
>> > wrote:
>> >>
>> >> Thank you - I was looking for a tool or script to get all the
>> >> permutations. =A0I'm not too good at doing it by hand. =A0:)
>> >>
>> >
>>
>>
>>
>> --
>> -tim
>
>



--=20
-tim
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
