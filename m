From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: Known-good LSI PCIe SAS HBAs?
Date: Mon, 14 Dec 2009 16:51:30 +0200
Message-ID: <4B2650F2.7070206@gmail.com>
References: <73e903670911100854o1b48380apb5b0a86c44ae9dcb@mail.gmail.com> <200911111151.09021.tfjellstrom@shaw.ca> <73e903670911131003i26f25b01xb6671684419d5c51@mail.gmail.com> <200911131159.26236.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200911131159.26236.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: tfjellstrom@shaw.ca
Cc: =?UTF-8?B?S3Jpc3RsZWlmdXIgRGHDsGFzb24=?= <kristleifur@gmail.com>, Richard Scobie <richard@sauce.co.nz>, linux-raid@vger.kernel.org, andy yan <andyysj@gmail.com>
List-Id: linux-raid.ids

Hello
Any news on the mvsas driver for this card? the MV8 is a ridiculously=20
attractive card, and proper linux support would be a boon to many peopl=
e=20
who want to use it on their fileservers.


On 13/11/2009 8:59 =CE=BC=CE=BC, Thomas Fjellstrom wrote:
> On Fri November 13 2009, Kristleifur Da=C3=B0ason wrote:
>   =20
>> On Wed, Nov 11, 2009 at 6:51 PM, Thomas Fjellstrom<tfjellstrom@shaw.=
ca>
>>     =20
> wrote:
>   =20
>>> On Wed November 11 2009, Richard Scobie wrote:
>>>       =20
>>>> Thomas Fjellstrom wrote:
>>>>         =20
>>>>> Thats the problem he was trying to get away from. the MV8
>>>>> controller likes to offline disks when a few smart commands arriv=
e.
>>>>> at least with the main kernel drivers. But then the main kernel
>>>>> mvsas drivers decide to give up if you even attempt to start a ra=
id
>>>>> array on them. The controller locks up and you have to reboot. Mo=
st
>>>>> of the time a reboot even fails when it tries to sync the block
>>>>> devices, so a hard reset is in order.
>>>>>           =20
>>>> OK, I did not know the Marvell controller also has a problem with
>>>> smartmontools.
>>>>         =20
>>> Given the state of the in kernel drivers, its probably a driver iss=
ue.
>>>       =20
>> Thanks for the replies, all.
>>
>> I'll bet it's the driver - it doesn't feel quite right that a random
>> external command can easily drop drives off the controller, be it
>> smartmontools or mdadm.
>>
>> Thomas, I tried sending a private email to Andy Yan. I haven't got a
>> reply, which kind of isn't surprising in this world of spam. Can I a=
sk
>> you for a referral - could you send him an email asking him if I can
>> have the patch and how to test it?
>>     =20
> He seems to be a busy guy, but I've CCed him on this. The actual driv=
er I
> got is a full copy of the driver, builds out of tree.
>
> He hasn't said I can't send the package to anyone, but I'll wait a li=
ttle
> while before doing so, he might pop up saying not to give it out.
>
> All I can say is: it works well enough for me*.
>
> For a $120 8 port sata card, it really does the trick. I was so glad =
when I
> didn't have to get several crappy 2-4 port jmicron cards.
>
>   =20
>> Also, to list-dwellers: I'd greatly appreciate further tips on PCIe =
SAS
>>   HBAs.
>>
>> Thanks!
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>     =20
> * Performance (to me) is outstanding, or at least it will be once the=
 write
> back stuff is fixed up, and the io controller stuff is also fixed up,=
 but as
> is right now in 2.6.31, its "good enough". Might not get the absolute=
 insane
> 400-500MB/s I saw with the controller originally, but I do get a good
> 100-230MB/s off my 5 drive md raid5 array (512KB chunk). I find thing=
s that
> used to take 30 seconds or more on my old array now happen in a few s=
econds.
> Right now writes are rather bad (60-100MB/s) but that I assume is the=
 write
> back stuff, which should hopefully be fixed in 32.
>
>   =20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
