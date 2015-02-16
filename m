From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID 1 metadata - keep separate from mirror disks ?
Date: Mon, 16 Feb 2015 08:02:31 -0500
Message-ID: <54E1EA67.3040308@turmel.org>
References: <79c7cd53-bb6c-4058-95ad-7ebd56cf1056@default> <54DB6BF0.3040309@turmel.org> <17135927-75bb-499a-8f43-6748c872feb0@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17135927-75bb-499a-8f43-6748c872feb0@default>
Sender: linux-raid-owner@vger.kernel.org
To: Suresh Babu Kandukuru <suresh.babu.kandukuru@oracle.com>, linux-raid@vger.kernel.org
Cc: Ankur Bose <ankur.bose@oracle.com>
List-Id: linux-raid.ids

Hi Suresh,

On 02/16/2015 06:37 AM, Suresh Babu Kandukuru wrote:
> Yeh . Thank Phil . it is quite useful .  Now we see there are two
> options . 1) without metadata 2) externally managed metadata . But we
> would like to keep the metadata external to mirror leg ( like on host
> local drive )  for the reasons mentioned below , not the externally
> managed metadata , just by keeping metadata on mirror legs . Do we
> have any option with md driver ?

I'm not sure I understand your follow-up question.  You've restated my
answer, and re-iterated your preference to not have metadata on the
member devices.

So you need to write a service to handle metadata the way you want.  Or
write scripts that will do --build operations at appropriate times
without metadata.

I'm not entirely clear why the on-member metadata is unacceptable, but
as such, either remaining option needs some code of your own.

Phil
