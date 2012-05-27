From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: very slow file deletion on an SSD
Date: Sun, 27 May 2012 11:07:02 -0500
Message-ID: <4FC25126.7070002@sandeen.net>
References: <4FBF60D1.80104@gmail.com> <20120526231838.GR25351@dastard> <4FC16683.9060800@gmail.com> <20120527000701.GS25351@dastard> <4FC18845.6030301@gmail.com> <4FC19408.5020502@sandeen.net> <CAAxjCEzX4dmm6YuR__1_a6mw+D=vizV0VrCLqCC-d5GSgkbE6g@mail.gmail.com> <1338124504.28212.255.camel@oxygen.netxsys.com> <5856C5F0-C13E-415D-907B-491C1BBCC0C2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5856C5F0-C13E-415D-907B-491C1BBCC0C2@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: joe.landman@gmail.com
Cc: Krzysztof Adamski <k@adamski.org>, Stefan Ring <stefanrin@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>
List-Id: linux-raid.ids

On 5/27/12 9:59 AM, joe.landman@gmail.com wrote:
> This is going to be a very fragmented file.  I am guessing that this
> is the reason for the long duration delete.   I'll do some more
> measurements before going to 3.4.x as per Eric's note.

filefrag -v should also tell you how many fragments, and because it
uses fiemap it probably won't run into the same problems.

But it sounds like we can just assume very high fragmentation.

It's not addressing the exact issue, but why are the files so fragmented?
Are they very hole-y or is it just an issue with how they are written?
Perhaps preallocation would help you here?

-Eric
