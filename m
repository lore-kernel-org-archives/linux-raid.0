From: David Brown <david.brown@hesbynett.no>
Subject: Re: make filesystem failed while the capacity of raid5 is big than
 16TB
Date: Tue, 18 Sep 2012 12:22:45 +0200
Message-ID: <50584B75.1060606@hesbynett.no>
References: <505033fe.8aec440a.5d52.ffffe37b@mx.google.com> <50504094.2040302@hesbynett.no> <CACY-59cLmV2SRY+FrvhHxseDD1+r-B-3bOKPGzJdGttW+9U2mw@mail.gmail.com> <505059DD.8000108@hesbynett.no> <CACY-59dAbS=8ncRAeZrAYBAvo7G6FEyoGREHtC-ze4cwhiF9GQ@mail.gmail.com> <5051DEC3.9050703@hardwarefreak.com> <CACY-59eJvv98xz_E-0qO_MGF8M40AZ-bCeXOA6zscd+HZdsy+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACY-59eJvv98xz_E-0qO_MGF8M40AZ-bCeXOA6zscd+HZdsy+g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: GuoZhong Han <hanguozhong@meganovo.com>
Cc: stan@hardwarefreak.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/09/2012 11:35, GuoZhong Han wrote:
> Hi Stan:
>          Thanks for your advice. In your last mail, you mentioned XFS
> file system. According to your suggestion, I changed the file system
> from raid5 (4*2T, chunksize: 128K, strip_catch_size:2048) to XFS. The=
n
> I did a write performance test on XFS.
> The test was as follows:
>          My program used 4 threads to do parallel writing to 30 files
> with 1MB/s writing speed on each file. Each thread was bound on a
> single core. The estimated total speed should be stable at 30MB/s. I
> recorded the total writing speed every second in the test. Compared
> with speed of ext4, when the array was going to be full, the
> performance of XFS has indeed increased. The time to create the XFS
> file system was much less than the cost of ext4. However, I found tha=
t
> the total speed wasn=92t steady. Although most of time the speed can
> reach to 30M/s, it fell to only about 10MB/s in rare cases. Writing t=
o
> 30 files in parallel was supposed to be easy. Why did this happen?
>
>

Two questions - what is the XFS built on? 4 x 2TB in a linear=20
concatenation, or something else?

Secondly, are all your files in the same directory, or in different=20
directories?  XFS scales by using multiple threads for different=20
allocation groups, and putting these groups in different places on the=20
underlying disk or disks - but files in the same directory go in the=20
same allocation group.  So 30 files in 30 directories will give much=20
more parallelism than 30 files in 1 directory.



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
