From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Wed, 23 May 2012 08:14:42 -0500
Message-ID: <4FBCE2C2.6030909@hardwarefreak.com>
References: <4FAAE8F1.8000600@pocock.com.au> <CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com> <4FABC7C6.4030107@turmel.org> <4FAC2FF2.5060305@hardwarefreak.com> <4FAC40BC.1060300@hesbynett.no> <CABYL=ToORULrdhBVQk0K8zQqFYkOomY-wgG7PpnJnzP9u7iBnA@mail.gmail.com> <4FACBB68.2080304@hesbynett.no> <4FACCAC8.4020206@pocock.com.au> <4FAD9283.7020809@hardwarefreak.com> <CAGqmV7oJg8vwKPJEYJhPANzaN-xxVW6Lw2gLTEKmMfG=pqCHuA@mail.gmail.com> <4FBA8EA9.40203@hardwarefreak.com> <20120522093404.3ffaae42@notabene.brown> <4FBB33D6.4010101@hardwarefreak.com> <4FBB406B.7040904@hesbynett.no>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FBB406B.7040904@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: NeilBrown <neilb@suse.de>, CoolCold <coolthecold@gmail.com>, Daniel Pocock <daniel@pocock.com.au>, Roberto Spadim <roberto@spadim.com.br>, Phil Turmel <philip@turmel.org>, Marcus Sorensen <shadowsor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/22/2012 2:29 AM, David Brown wrote:

> But in general, it's important to do some real-world testing to
> establish whether or not there really is a bottleneck here.  It is
> counter-productive for Stan (or anyone else) to advise against raid10 or
> raid5/6 because of a single-thread bottleneck if it doesn't actually
> slow things down in practice.  

Please reread precisely what I stated earlier:

"Neil pointed out quite some time ago that the md RAID 1/5/6/10 code
runs as a single kernel thread.  Thus when running heavy IO workloads
across many rust disks or a few SSDs, the md thread becomes CPU bound,
as it can only execute on a single core, just as with any other single
thread."

Note "heavy IO workloads".  The real world testing upon which I based my
recommendation is in this previous thread on linux-raid, of which I was
a participant.

Mark Delfman did the testing which revealed this md RAID thread
scalability problem using 4 PCIe enterprise SSDs:

http://marc.info/?l=linux-raid&m=131307849530290&w=2

> On the other hand, if it /is/ a hinder to
> scaling, then it is important for Neil and other experts to think about
> how to change the architecture of md raid to scale better.  And

More thorough testing and identification of the problem is definitely
required.  Apparently few people are currently running md RAID 1/5/6/10
across multiple ultra high performance SSDs, people who actually need
every single ounce of IOPS out of each device in the array.  But this
trend will increase.  I'd guess those currently building md 1/5/6/10
arrays w/ many SSDs simply don't *need* every ounce of IOPS, or more
would be complaining about single core thread limit already.

> somewhere in between there can be guidelines to help users - something
> like "for an average server, single-threading will saturate raid5
> performance at 8 disks, raid6 performance at 6 disks, and raid10 at 10
> disks, beyond which you should use raid0 or linear striping over two or
> more arrays".

This isn't feasible due to the myriad possible combinations of hardware.
 And you simply won't see this problem with SRDs (spinning rust disks)
until you have hundreds of them in a single array.  It requires over 200
15K SRDs in RAID 10 to generate only 30K random IOPS.  Just about any
single x86 core can handle that, probably even a 1.6GHz Atom.  This
issue mainly affects SSD arrays, where even 8 midrange consumer SATA3
SSDs in RAID 10 can generate over 400K IOPS, 200K real and 200K mirror data.

> Of course, to do such testing, someone would need a big machine with
> lots of disks, which is not otherwise in use!

Shouldn't require anything that heavy.  I would guess that one should be
able to reveal the thread bottleneck with a low freq dual core desktop
system with an HBA such as the LSI 9211-8i @320K IOPS, and 8 Sandforce
2200 based SSDs @40K write IOPS each.

-- 
Stan
