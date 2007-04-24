From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Subject: Re: Multiple disk failure, but slot numbers are corrupt and preventing assembly.
Date: Tue, 24 Apr 2007 09:17:17 +0200
Message-ID: <c384c5ea0704240017m6963deet58b28b67377e8f91@mail.gmail.com>
References: <c384c5ea0704231017i2fd01aceva845a2f61f0aae3@mail.gmail.com>
	 <462CF303.6030004@dgreaves.com>
	 <c384c5ea0704240004r176372e1nb384c06e558dd1f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c384c5ea0704240004r176372e1nb384c06e558dd1f@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/24/07, Leon Woestenberg <leon.woestenberg@gmail.com> wrote:
> Hello,
>
> On 4/23/07, David Greaves <david@dgreaves.com> wrote:
> > There is some odd stuff in there:
> >
> [root@localhost ~]# mdadm -v --assemble --scan --config=/tmp/mdadm.conf --force
> [...]
> mdadm: no uptodate device for slot 1 of /dev/md0
> mdadm: no uptodate device for slot 2 of /dev/md0
> [...]
>
So, the problem I am facing is that the slot number (as seen with
--examine) is invalid on two and therefore they won't be recognized as
valid drives for the array.

Is there any way to override the slot number? I could not find
anything in mdadm or mdadm.conf to override them.

-- 
Leon
