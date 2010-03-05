From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: RAID MIA. Again. (Kinda.)
Date: Fri, 5 Mar 2010 12:05:32 -0800
Message-ID: <4877c76c1003051205i23998a72xc9df3174c1e7fd17@mail.gmail.com>
References: <ef2f0a4210283390480f4adbd9a547de.squirrel@webmail.jots.org>
	 <20100305075016.51e98363@notabene.brown>
	 <b305ada429c44b2b62b03c101f7ecf0a.squirrel@webmail.jots.org>
	 <20100305123028.55a34c14@notabene.brown>
	 <a65d84c03d315f1aea40641238f25625.squirrel@webmail.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a65d84c03d315f1aea40641238f25625.squirrel@webmail.jots.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ken D'Ambrosio <ken@jots.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 5, 2010 at 7:24 AM, Ken D'Ambrosio <ken@jots.org> wrote:
> On Thu, March 4, 2010 8:30 pm, Neil Brown wrote:
>> Try this:
>>
>>
>> cat /etc/fstab cat /etc/mdadm.conf mdadm -Esvv mdadm -Asv blkid -p /=
dev/md*
>>
>> And include all the output.
>
> See attached. =A0Note that fstab is essentially irrelevant; I'd mount=
ed by
> hand, and was going to add the entry after I got the server back in t=
he
> server room.
>
>> (sorry if I seem grumpy, but I'm a bit tired which makes it harder t=
o
>> appear polite).
>
> Know what you mean; got four hours', myself, due to a virtualization
> migration.
>
> For the record, I've got my backup tapes ordered (again) -- if you ca=
n
> tell me what I did wrong, that would be almost as satisfying as getti=
ng
> the data back.
>
> Thanks,
>
> -Ken
> --
> This message has been scanned for viruses and
> dangerous content by MailScanner, and is
> believed to be clean.
>
>

Here's a stab at it. I've never tried to do it like this and haven't
glanced at the code so I can't be sure, but this seems to be the most
likely suspect:

#ARRAY /dev/md0 level=3Draid5 num-devices=3D4 devices=3Dsda2,sdb2,sdd2,=
sdc2

Your commented out version seems to specify this mapping
0,sda2
1,sdb2
2,sdd2
3,sdc2

However the array is detected like this by uuid alone (I re-ordered
the entries so they're easier to read):

mdadm: /dev/sdb2 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdc2 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sda2 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdd2 is identified as a member of /dev/md0, slot 3.
mdadm: added /dev/sdb2 to /dev/md0 as 0
mdadm: added /dev/sdc2 to /dev/md0 as 1
mdadm: added /dev/sda2 to /dev/md0 as 2
mdadm: added /dev/sdd2 to /dev/md0 as 3
mdadm: /dev/md0 has been started with 4 drives.

This corresponds to:

0,sdb2
1,sdc2
2,sda2
3,sdd2

Note how the drives are out of order?  Thus the reason for  only using
UUID and NOT explicitly specifying an ordering?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
