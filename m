From: Jonathan <jrs@abhost.net>
Subject: Re: data recovery on raid5
Date: Sat, 22 Apr 2006 13:55:29 -0700
Message-ID: <444A9841.8070202@abhost.net>
References: <444A7C99.80006@abhost.net>	 <62b0912f0604221248s653843bfx363f346c7ef31a94@mail.gmail.com>	 <444A8D04.20809@abhost.net>	 <62b0912f0604221322k25c96c37q2bee9361a6316c1b@mail.gmail.com>	 <444A92CF.70401@abhost.net> <62b0912f0604221338m6b9fc06do61d78ffa622523bc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0604221338m6b9fc06do61d78ffa622523bc@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hazel /virtual # mdadm -C /dev/md0 -c 32 -n 4 -l 5 
--parity=left-asymmetric missing /dev/etherd/e0.[023]
mdadm: /dev/etherd/e0.0 appears to be part of a raid array:
    level=5 devices=4 ctime=Sat Apr 22 13:25:40 2006
mdadm: /dev/etherd/e0.2 appears to be part of a raid array:
    level=5 devices=4 ctime=Sat Apr 22 13:25:40 2006
mdadm: /dev/etherd/e0.3 appears to contain an ext2fs file system
    size=720300416K  mtime=Wed Oct  5 16:39:28 2005
mdadm: /dev/etherd/e0.3 appears to be part of a raid array:
    level=5 devices=4 ctime=Sat Apr 22 13:25:40 2006
Continue creating array? y
mdadm: array /dev/md0 started.
hazel /virtual # mount -t ext2 -r /dev/md0 /md0
hazel /virtual # df -H
Filesystem             Size   Used  Avail Use% Mounted on
/dev/hda4               67G   5.8G    58G  10% /
udev                   526M   177k   526M   1% /dev
/dev/hda3              8.1G    34M   7.7G   1% /tmp
none                   526M      0   526M   0% /dev/shm
/dev/md1               591G    11G   551G   2% /virtual
/dev/md0               591G    54G   507G  10% /md0

now I'm doing a:

(cd /md0 && tar cf - . ) | (cd /virtual/recover/ && tar xvfp -)

thank you thank you thank you thank you thank you thank you


Molle Bestefich wrote:

>Jonathan wrote:
>  
>
>>Well, the block sizes are back to 32k now, but I still had no luck
>>mounting /dev/md0 once I created the array.
>>    
>>
>
>Ahem, I missed something.
>Sorry, the 'a' was hard to spot.
>
>Your array used layout : left-asymmetric, while the superblock you've
>just created has layout: left-symmetric.
>
>Try again, but add the option "--parity=left-asymmetric"
>

