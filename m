From: forumscollective@gmail.com
Subject: Re: Expand RAID5 array or switch to RAID10
Date: Mon, 22 Dec 2014 07:57:16 +0200
Message-ID: <F5D9EF1B-CC07-4C0E-B7F2-53A99E21193F@gmail.com>
References: <CAG__1a7YqAWMccgDeYksY_t10Zyy8Rc-veZM_P7aaXs-DtFdfQ@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAG__1a7YqAWMccgDeYksY_t10Zyy8Rc-veZM_P7aaXs-DtFdfQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

anyone?

Sent from my iPhone

> On 17 Dec 2014, at 12:11, George Duffield <forumscollective@gmail.com> wrote:
> 
> Hi
> 
> I have a RAID5 array comprising four 3TB drives and I've basically got
> 100GB remaining free so it's time to expand the array.  With this in
> mind, and considering my requirement is predominantly to increase
> capacity, I'm wondering whether it'd be best to add another 3TB drive
> and expand the array whilst retaining RAID5 or to switch out to a
> RAID10 array.  My thinking is 1) adding a 5th 3TB drive to the
> existing array may result in drive failure during the rebuild; and 2)
> RAID10 is very expensive to implement.  Hence, I'm tempted to consider
> other options (recognising that whilst it'd be convenient I don't
> actually need everything stored on a single array).   One such option
> would be running two raid5 arrays comprised of 3x 3TB each yielding
> 12TB of storage across the two arrays.
> 
> 
> Questions:
> + Is my assumption re RAID5 drive failure correct/ likely?
> + Is there a non-destructive way to migrate from RAID5 to RAID10?
> + 2 x RAID5 arrays seems pretty appealing - from a reliability and
> cost effectiveness standpoint - yes/no?
