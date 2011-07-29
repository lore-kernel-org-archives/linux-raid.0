From: Doug Ledford <dledford@redhat.com>
Subject: Re: RAID 1 using SSD and 2 HDD
Date: Fri, 29 Jul 2011 14:31:08 -0400
Message-ID: <4E32FC6C.6010409@redhat.com>
References: <4E25C9BA.1060401@dodtsair.com> <201107290153.45227.xavier@alternatif.org> <4E327E12.30900@anonymous.org.uk> <201107291950.22550.xavier@alternatif.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201107291950.22550.xavier@alternatif.org>
Sender: linux-raid-owner@vger.kernel.org
To: Xavier Brochard <xavier@alternatif.org>
Cc: John Robinson <john.robinson@anonymous.org.uk>, brian.foster@emc.com, mpower@dodtsair.com, rm@romanrm.ru, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/29/2011 01:50 PM, Xavier Brochard wrote:
> Le vendredi 29 juillet 2011 11:32:02 John Robinson, vous avez =E9crit=
 :
>> On 29/07/2011 00:53, Xavier Brochard wrote:
>>> Le jeudi 28 juillet 2011 20:31:10 Doug Ledford, vous avez =E9crit :
>>>> On 07/20/2011 08:59 AM, brian.foster@emc.com wrote:
>> [...]
>>
>>>>>> On 07/19/2011 11:32 AM, Roman Mamedov wrote:
>> [...]
>>
>>>>>>> See http://bcache.evilpiepirate.org/
>>
>> [...]
>>
>>>>> https://github.com/facebook/flashcache
>>>>
>>>> Having not looked at those two, I can say that an md raid1 with tw=
o hard
>>>> drives and one SSD works *very* well.  It's blazing fast.  Here's =
how I
>>>> set mine up:
>>>>
>>>> SSD: three partitions, one for boot, one for /, and one for ~/repo=
s
>>>> (which is where all my git/cvs/etc. checkouts reside)
>>>> hard disks: four partitions, one for boot, one for /, one for /hom=
e, one
>>>> for ~/repos
>>>>
>>>> Then I created four raid1 arrays like so:
>>>>
>>>> mdadm -C /dev/md/boot -l1 -n3 -e1.0 --bitmap=3Dinternal --name=3Db=
oot
>>>> /dev/sda1 --write-mostly --write-behind=3D128 /dev/sdb1 /dev/sdc1
>>>> mdadm -C /dev/md/root -l1 -n3 -e1.2 --bitmap=3Dinternal --name=3Dr=
oot
>>>> /dev/sda2 --write-mostly --write-behind=3D1024 /dev/sdb2 /dev/sdc2
>>>> mdadm -C /dev/md/home -l1 -n2 -e1.2 --bitmap=3Dinternal --name=3Dh=
ome
>>>> /dev/sdb3 /dev/sdc3
>>>> mdadm -C /dev/md/repos -l1 -n3 -e1.2 --bitmap=3Dinternal --name=3D=
repos
>>>> /dev/sda4 --write-mostly --write-behind=3D1024 /dev/sdb4 /dev/sdc4
>>>>
>>>> Works for me with stellar performance.  Treats the SSD as the only
>>>> device that matters on the three arrays it participates in with th=
e hard
>>>> drives there merely as a backing store for safety in case the SSD =
blows
>>>> chunks some day.  Obviously, if you need some other aspect of your=
 home
>>>> directory to have the SSD benefit then modify to your tastes, but =
all my
>>>> scratch builds happen under ~/repos and the thing flies when compi=
ling
>>>> stuff compared to how it used to be.
>>>
>>> One thing you didn't said is the respective size of the SSD and HD
>>> partitions. How did you determine them?
>>
>> Since he's running RAID-1, the partitions on the SSD and HDDs must b=
e
>> the same size. Note that the rest of the space on the HDDs was given=
 to
>> /home and was not mirrored on the SSD.
>
> Oh... I thought It was more like Mike's request:
> "a RAID 1 array using two equal size HDD and one smaller and faster S=
SD"
>
>
> Xavier
> xavier@alternatif.org

It is.  The SSD is 128GB and the two HDs are 500GB.  The /home partitio=
n=20
does not exist on the SSD and it exactly equals the amount of space lef=
t=20
over on the two HDs after they have had matching partitions created to=20
duplicate the partitions on the SSD.


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
