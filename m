From: Pierre Martineau <pierre.martineau@inserm.fr>
Subject: Re: RAID5 recovering
Date: Mon, 15 Apr 2013 17:58:40 +0200
Message-ID: <516C23B0.3000003@inserm.fr>
References: <516C04FB.3030604@inserm.fr> <20130415151939.GA8383@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000101090602010409090100"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130415151939.GA8383@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------000101090602010409090100
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

Thanks a lot!
The array seems to start with only minor problems

mdadm: forcing event count in /dev/sdd1(3) from 112333 upto 112358
mdadm: clearing FAULTY flag for device 1 in /dev/md0 for /dev/sdd1
mdadm: /dev/md0 has been started with 3 drives (out of 4).

File systems are corrupted but not too seriously.
I will have a look for RAID6 in the future.

Thanks again,
Pierre

Pierre MARTINEAU

Institut de Recherche en Canc=E9rologie de Montpellier
Inserm U896 =96 Universit=E9 Montpellier 1 =96 CRLC Val d=92Aurelle
Campus Val d=92Aurelle
208 Rue des Apothicaires
F-34298 Montpellier Cedex 5, France

Tel: +33 (0)4 67 61 37 43
Fax: +33 (0)4 67 61 37 87
E-mail: pierre.martineau@inserm.fr
E-mail: pierre.martineau@montpellier.unicancer.fr
Site internet: http://www.ircm.fr

Le 15/04/2013 17:19, Robin Hill a =E9crit :
> On Mon Apr 15, 2013 at 03:47:39PM +0200, Pierre Martineau wrote:
>
>> Dear Raid experts,
>>
>> I have a Raid5 volume that recently crashed and I need you advices
>> before doing some irreversible action.
>>
>> Let me first summarize the past and current state.
>>
>> 1) I had a nicely running RAID5 volume with 3 x 1 To disks (LVM on top
>> and several LVM volumes in ext3 and axt4) but volume was now a bit too
>> small and I decided to add a new 1 To disk.
>>
> Given the rebuild time for a 1To disk, I'd be wary of running RAID5 - i=
f
> you have the space, adding another disk and going to RAID6 will be much
> safer.
>
>> 2) I added a new disk and did not do anything for a couple of days (Ra=
id
>> still running with 3 disks)
>>
>> 3) One of the old disk failed and was ejected from the RAID.
>>
>> 4) The ejected disk was not even present as /dev/sdX. I thus tested th=
e
>> connections and the disk came back.
>>
>> 5) I resync the ejected disk and I was back with my original 3 disk ar=
ray.
>>
>> 6) I waited 2-3 days and everything was fine. I then added the new dis=
k
>> and resync.
>>
>> 7) I had now a running 4 disk RAID5 array, I created a new volume and
>> started copying on it.
>>
>> 8) During the week-end, 2 disks were ejected from the array, the new
>> installed one and the same than previously (step 3)
>>
>> 9) Again the 2 disks were not present in /dev/sdX. I thus checked agai=
n
>> the connections and the problem was a molex connector. The two ejected
>> disks were on the same molex and this explains why both were detected =
as
>> faulty.
>>
>> Now, my list of errors as a newbie.
>>
>> 4) I did not save all the informations before proceeding (mdadm
>> --examine, /etc/mdadm/mdadm.conf, syslog, ...)
>>
>> 5) I tried to assemble the disks with
>> mdadm --assemble --scan
>> with no result
>>
>> 6) I thus tried and this is my big error I think !!!
>> mdadm --assemble /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
>>
>> I forgot in this command /dev/md0 after assemble.
>> Because of this /dev/sdb1 suberblock was removed and now mdadm--examin=
e
>> /dev/sdb1 returns "No md superblock detected on /dev/sdb1"
>>
>> I would like now to be more cautious. If some nice expert from the lis=
t
>> would be nice enough to tell me if the proposed method described below
>> is the right approach I will be grateful for the rest of my life :-)
>>
>> 7) I read the RAID wiki and the list.
>>
>> 8) I saved
>> mdadm --examine /dev/sd[bcde]1
>> dmesg
>> syslog
>> /etc/mdadm/mdadm.conf
>> fdisk -lu /dev/sd[bcde]
>>
>> I put the content of this files at the end of this message (except dme=
sg
>> and syslog because they are very long).
>>
>> 9) /dev/sdd is the new disk. This is clear in the fdisk listing since =
it
>> is a 4K sector disk.
>> The normal order of the raid is thus (see mdadm --examine /dev/sd[de]1=
)
>> sdb1 sdc1 sde1 sdd1
>>
>> 10) Events are
>> /dev/sdb1: no md superblock (see 6)
>> /dev/sdc1: Events : 112358
>> /dev/sdd1: Events : 112333
>> /dev/sde1: Events : 112358
>>
>> It seems that sdd was the first disk removed.
>> Presumably sdb1 is in sync since it was running with sdc1 when the sdd=
1
>> and sde1 were ejected from the array (see 8) but I can't be sure since=
 I
>> stupidly erased its superblock!
>>
>> 11) I propose to re-create the array with the --assume-clean option,
>> then check everything using "fsck -n" and "mount -o ro"
>> the command would be:
>>
>> mdadm --create /dev/md0 -e 0.90 --assume-clean --level=3D5 --n=3D4 \
>> --chunk=3D64 --size=3D976759936 /dev/sdb1 /dev/sdc1 /dev/sde1 /dev/sdd=
1
>>
> <-- snip -->
>
> Have you tried to force assemble the array first? Recreating the array
> is a risky option, so should be avoided if possible. First try doing:
>    mdadm -Af /dev/md0 /dev/sd[cde]1
>
> If that works then you'll need to re-add (and rebuild) /dev/sdb1. If it
> doesn't work, try rerunning (after making sure the array is stopped) an=
d
> adding "-vvv" for extra verbosity, then send through the output from
> that and anything relevant from dmesg.
>
> HTH,
>      Robin


--------------000101090602010409090100
Content-Type: text/x-vcard; charset=utf-8;
 name="pierre_martineau.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="pierre_martineau.vcf"

begin:vcard
fn:Pierre MARTINEAU
n:MARTINEAU;Pierre
org:INSERM U896;IRCM
adr:208 rue des Apothicaires;;CRLC Val d'Aurelle-Paul Lamarque;Montpellier;;34298;France
email;internet:pierre.martineau@inserm.fr
tel;work:+33 (0)4 67 61 37 43
tel;fax:+33 (0)4 67 61 37 87
x-mozilla-html:FALSE
url:http://www.ircm.fr
version:2.1
end:vcard


--------------000101090602010409090100--
