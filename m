From: Stefan *St0fF* Huebner <st0ff@gmx.net>
Subject: Re: using dd (or dd_rescue) to salvage array
Date: Tue, 07 Feb 2012 21:01:01 +0100
Message-ID: <4F3182FD.9030602@gmx.net>
References: <CAOANJV955ZdLexRTjVkQzTMapAaMitq5eqxP0rUvDjjLh4Wgzw@mail.gmail.com> <4F309313.2070406@turmel.org> <k4i609x025.ln2@goaway.wombat.san-francisco.ca.us> <4F309CB3.2080400@turmel.org> <8eekv8xpcn.ln2@goaway.wombat.san-francisco.ca.us> <kesmv8xc66.ln2@goaway.wombat.san-francisco.ca.us> <0cdtv8xv8f.ln2@goaway.wombat.san-francisco.ca.us> <4F2D7280.8020500@stud.tu-ilmenau.de> <8q0309x4kf.ln2@goaway.wombat.san-francisco.ca.us> <4F304822.8000102@gmx.net> <20120207042407.GA5927@wombat.san-francisco.ca.us>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120207042407.GA5927@wombat.san-francisco.ca.us>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07.02.2012 05:24, Keith Keller wrote:
> On Mon, Feb 06, 2012 at 10:37:38PM +0100, Stefan *St0fF* Huebner wrote:
>>  From the logical point of view those lost 8k would create bad data -
>> i.e. a filesystem problem OR simply corrupted data.  That depends on
>> which blocks exactly are bad.  If you were using lvm it could even be
>> worse, like broken metadata.
> FWIW, xfs_repair has spit out over 100k lines on stderr, but when I
> mounted before the repair (this is suggested if you need to replay the
> log), everything seemed intact.  So I'm not yet sure what to make of
> things; perhaps it'll be fine, or perhaps I need to start over.
> (Alternatively, perhaps the next rsnapshot run will expose problems.)
>
>
> On Mon, Feb 06, 2012 at 10:38:27PM -0500, Phil Turmel wrote:
>> But, I reviewed the OEM documentation for the 7K3000 family, and they
>> clearly document support for the SCT ERC commands (para 9.18.1.2).
> If I'm reading the docs right, then the 5K3000 also supports them (if
> you're really cheap and can tolerate the slower speeds).  At this point,
> if we're waiting till April for real ''enterprise'' drives, I can't see
> anything too bad about getting one or two of these and testing them out
> in my environment--the EARS drives are bad enough with my configuration
> that it's hard to imagine being any worse.  (To be fair, I have to blame
> the 3ware 9550 controller a bit too; I have EARS drives on other 3ware
> controllers without all these issues.)
>
> --keith
>
>
>
Sounds promising.  If you're really lucky, the blocks were freed by the 
fs and nothing has gone...

Stefan
