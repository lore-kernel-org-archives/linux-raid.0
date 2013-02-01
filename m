From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid 5 to 6 migration
Date: Fri, 01 Feb 2013 13:19:23 -0500
Message-ID: <510C072B.1030108@turmel.org>
References: <BLU0-SMTP433B0BCF64D448CC81098D2C91C0@phx.gbl> <510C0075.9010908@turmel.org> <20130202001625.2b7d6514@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130202001625.2b7d6514@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Dominique <dcouot@hotmail.com>, linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/01/2013 01:16 PM, Roman Mamedov wrote:
> On Fri, 01 Feb 2013 12:50:45 -0500
> Phil Turmel <philip@turmel.org> wrote:
> 
>> On 02/01/2013 12:17 PM, Dominique wrote:
>>> Hi list,
>>>
>>> I was wondering what would be the best way to convert a 6 hdd raid 5 to
>>> raid 6. Ideally without having to reformat everything and lose all the
>>> data in the process. I have backups of the data but I don't look forward
>>> reinstalling everything on that server.
> 
> ...
> 
>> 3) Convert array to raid6 w/ "mdadm --grow --level=raid6"
> 
> --layout=preserve will make it an order of magnitude faster. Read "man mdadm"
> for more details. (And "man md" to learn about things in general.)

But will leave the array "unbalanced"--the 7th drive will never be used
for reads in normal (non-degraded) operation--reducing read performance.

> That's all while still assuming you *can* or want to add a 7th drive.
> If not, things become more complex.

Indeed.

Phil

