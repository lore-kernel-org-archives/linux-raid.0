From: Robin Doherty <rdoherty@gmail.com>
Subject: Re: mdadm raid5 array - 0 space available but usage is less than capacity
Date: Thu, 23 Sep 2010 21:12:09 +0100
Message-ID: <AANLkTinDxLcCYr7=kR_3LSgcHt4hc8-NDmNc6tzQY2nr@mail.gmail.com>
References: <AANLkTi=XoxYmj8G5+GadCCTxQGJqpMttmU3NMH_vtKYM@mail.gmail.com> <alpine.LRH.2.00.1009231552110.5895@limbo.sharcnet.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.00.1009231552110.5895@limbo.sharcnet.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Kaizaad Bilimorya <kaizaad@sharcnet.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, it's an ext3 file system. Here's the output of df -Ti

=46ilesystem    Type    Inodes   IUsed   IFree IUse% Mounted on
/dev/md1      ext3   1466368  215121 1251247   15% /
varrun       tmpfs    257853      85  257768    1% /var/run
varlock      tmpfs    257853       2  257851    1% /var/lock
udev         tmpfs    257853    3193  254660    2% /dev
devshm       tmpfs    257853       1  257852    1% /dev/shm
/dev/md0      ext3     48192      38   48154    1% /boot
/dev/md2      ext3   242147328  151281 241996047    1% /share

Cheers
Rob


On 23 September 2010 20:53, Kaizaad Bilimorya <kaizaad@sharcnet.ca> wro=
te:
>
>
> On Thu, 23 Sep 2010, Robin Doherty wrote:
>
>> I have a RAID5 array of 5 1TB disks that has worked fine for 2 years
>> but now says that it has 0 space available (even though it does have
>> space available). It will allow me to read from it but not write. I
>> can delete things, and the usage goes down but the space stays at 0.
>>
>> I can touch but not mkdir:
>>
>> rob@cholera ~ $ mkdir /share/test
>> mkdir: cannot create directory `/share/test': No space left on devic=
e
>> rob@cholera ~ $ touch /share/test
>> rob@cholera ~ $ rm /share/test
>> rob@cholera ~ $
>>
>> Output from df -h (/dev/md2 is the problem array):
>>
>> Filesystem =A0 =A0 =A0 =A0 =A0 =A0Size =A0Used Avail Use% Mounted on
>> /dev/md1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 23G =A0 15G =A06.1G =A072% /
>> varrun =A0 =A0 =A0 =A0 =A0 =A0 =A0 1008M =A0328K 1007M =A0 1% /var/r=
un
>> varlock =A0 =A0 =A0 =A0 =A0 =A0 =A01008M =A0 =A0 0 1008M =A0 0% /var=
/lock
>> udev =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1008M =A0140K 1008M =A0 1% /dev
>> devshm =A0 =A0 =A0 =A0 =A0 =A0 =A0 1008M =A0 =A0 0 1008M =A0 0% /dev=
/shm
>> /dev/md0 =A0 =A0 =A0 =A0 =A0 =A0 =A0183M =A0 43M =A0131M =A025% /boo=
t
>> /dev/md2 =A0 =A0 =A0 =A0 =A0 =A0 =A03.6T =A03.5T =A0 =A0 0 100% /sha=
re
>>
>> and without the -h:
>>
>> Filesystem =A0 =A0 =A0 =A0 =A0 1K-blocks =A0 =A0 =A0Used Available U=
se% Mounted on
>> /dev/md1 =A0 =A0 =A0 =A0 =A0 =A0 =A023261796 =A015696564 =A0 6392900=
 =A072% /
>> varrun =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1031412 =A0 =A0 =A0 328 =A0 1=
031084 =A0 1% /var/run
>> varlock =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A01031412 =A0 =A0 =A0 =A0 0 =A0=
 1031412 =A0 0% /var/lock
>> udev =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1031412 =A0 =A0 =A0 140 =A0=
 1031272 =A0 1% /dev
>> devshm =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1031412 =A0 =A0 =A0 =A0 0 =A0=
 1031412 =A0 0% /dev/shm
>> /dev/md0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0186555 =A0 =A0 43532 =A0 =A0=
133391 =A025% /boot
>> /dev/md2 =A0 =A0 =A0 =A0 =A0 =A0 3843709832 3705379188 =A0 =A0 =A0 =A0=
 0 100% /share
>
>
> Just a shot in the dark but I have seen this with Lustre systems. Wha=
t does
> "df -i" show?
>
> thanks
> -k
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
