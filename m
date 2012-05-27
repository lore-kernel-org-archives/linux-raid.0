From: Joe Landman <joe.landman@gmail.com>
Subject: Re: very slow file deletion on an SSD
Date: Sun, 27 May 2012 13:17:05 -0400
Message-ID: <4FC26191.2050901@gmail.com>
References: <4FBF60D1.80104@gmail.com> <20120526231838.GR25351@dastard> <4FC16683.9060800@gmail.com> <20120527000701.GS25351@dastard> <4FC18845.6030301@gmail.com> <4FC19408.5020502@sandeen.net> <CAAxjCEzX4dmm6YuR__1_a6mw+D=vizV0VrCLqCC-d5GSgkbE6g@mail.gmail.com> <1338124504.28212.255.camel@oxygen.netxsys.com> <5856C5F0-C13E-415D-907B-491C1BBCC0C2@gmail.com> <4FC25126.7070002@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FC25126.7070002@sandeen.net>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Krzysztof Adamski <k@adamski.org>, Stefan Ring <stefanrin@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>
List-Id: linux-raid.ids

On 05/27/2012 12:07 PM, Eric Sandeen wrote:
> On 5/27/12 9:59 AM, joe.landman@gmail.com wrote:
>> This is going to be a very fragmented file.  I am guessing that this
>> is the reason for the long duration delete.   I'll do some more
>> measurements before going to 3.4.x as per Eric's note.
>
> filefrag -v should also tell you how many fragments, and because it
> uses fiemap it probably won't run into the same problems.
>
> But it sounds like we can just assume very high fragmentation.
>
> It's not addressing the exact issue, but why are the files so fragmented?
> Are they very hole-y or is it just an issue with how they are written?
> Perhaps preallocation would help you here?

... and one pass with xfs_fsr seems to have "fixed" the problem

[root@siFlash test]# xfs_fsr
xfs_fsr -m /proc/mounts -t 7200 -f /var/tmp/.fsrlast_xfs ...
/data/1 start inode=0
/data/2 start inode=0
/data/3 start inode=0
/data/1 start inode=0
/data/2 start inode=0
/data/3 start inode=0
/data/1 start inode=0
/data/2 start inode=0
/data/3 start inode=0
/data/1 start inode=0
/data/2 start inode=0
/data/3 start inode=0
/data/1 start inode=0
/data/2 start inode=0
/data/3 start inode=0
/data/1 start inode=0
/data/2 start inode=0
/data/3 start inode=0
/data/1 start inode=0
/data/2 start inode=0
/data/3 start inode=0
/data/1 start inode=0
/data/2 start inode=0
/data/3 start inode=0
/data/1 start inode=0
/data/2 start inode=0
/data/3 start inode=0
/data/1 start inode=0
/data/2 start inode=0
/data/3 start inode=0
Completed all 10 passes
[root@siFlash test]# filefrag  1.r.48.0
1.r.48.0: 1 extent found

[root@siFlash test]# rm -f 1.r.48.0

(very fast)

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615

