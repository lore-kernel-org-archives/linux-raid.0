From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID 1 using SSD and 2 HDD
Date: Fri, 29 Jul 2011 10:32:02 +0100
Message-ID: <4E327E12.30900@anonymous.org.uk>
References: <4E25C9BA.1060401@dodtsair.com> <24EACA6AC4B506428C92FE7C172FEF4E02084CF0@MX16A.corp.emc.com> <4E31AAEE.30601@redhat.com> <201107290153.45227.xavier@alternatif.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201107290153.45227.xavier@alternatif.org>
Sender: linux-raid-owner@vger.kernel.org
To: Xavier Brochard <xavier@alternatif.org>
Cc: Doug Ledford <dledford@redhat.com>, brian.foster@emc.com, mpower@dodtsair.com, rm@romanrm.ru, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29/07/2011 00:53, Xavier Brochard wrote:
> Le jeudi 28 juillet 2011 20:31:10 Doug Ledford, vous avez =E9crit :
>> On 07/20/2011 08:59 AM, brian.foster@emc.com wrote:
[...]
>>>> On 07/19/2011 11:32 AM, Roman Mamedov wrote:
[...]
>>>>> See http://bcache.evilpiepirate.org/
[...]
>>> https://github.com/facebook/flashcache
>>
>> Having not looked at those two, I can say that an md raid1 with two =
hard
>> drives and one SSD works *very* well.  It's blazing fast.  Here's ho=
w I
>> set mine up:
>>
>> SSD: three partitions, one for boot, one for /, and one for ~/repos
>> (which is where all my git/cvs/etc. checkouts reside)
>> hard disks: four partitions, one for boot, one for /, one for /home,=
 one
>> for ~/repos
>>
>> Then I created four raid1 arrays like so:
>>
>> mdadm -C /dev/md/boot -l1 -n3 -e1.0 --bitmap=3Dinternal --name=3Dboo=
t
>> /dev/sda1 --write-mostly --write-behind=3D128 /dev/sdb1 /dev/sdc1
>> mdadm -C /dev/md/root -l1 -n3 -e1.2 --bitmap=3Dinternal --name=3Droo=
t
>> /dev/sda2 --write-mostly --write-behind=3D1024 /dev/sdb2 /dev/sdc2
>> mdadm -C /dev/md/home -l1 -n2 -e1.2 --bitmap=3Dinternal --name=3Dhom=
e
>> /dev/sdb3 /dev/sdc3
>> mdadm -C /dev/md/repos -l1 -n3 -e1.2 --bitmap=3Dinternal --name=3Dre=
pos
>> /dev/sda4 --write-mostly --write-behind=3D1024 /dev/sdb4 /dev/sdc4
>>
>> Works for me with stellar performance.  Treats the SSD as the only
>> device that matters on the three arrays it participates in with the =
hard
>> drives there merely as a backing store for safety in case the SSD bl=
ows
>> chunks some day.  Obviously, if you need some other aspect of your h=
ome
>> directory to have the SSD benefit then modify to your tastes, but al=
l my
>> scratch builds happen under ~/repos and the thing flies when compili=
ng
>> stuff compared to how it used to be.
>
> One thing you didn't said is the respective size of the SSD and HD pa=
rtitions.
> How did you determine them?

Since he's running RAID-1, the partitions on the SSD and HDDs must be=20
the same size. Note that the rest of the space on the HDDs was given to=
=20
/home and was not mirrored on the SSD.

Cheers,

John.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
