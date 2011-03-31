From: hansbkk@gmail.com
Subject: Re: looking for advice on raid drives upgrade
Date: Thu, 31 Mar 2011 13:54:34 +0700
Message-ID: <BANLkTimDKBkEgt12yyowbo3-OzTiiV-BeQ@mail.gmail.com>
References: <imuu5b$gaf$1@dough.gmane.org>
	<alpine.DEB.2.00.1103301309100.1942@uplift.swm.pp.se>
	<imv3q2$h48$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <imv3q2$h48$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Vincent Schut <schut@sarvision.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 30, 2011 at 6:22 PM, Vincent Schut <schut@sarvision.nl> wrote:
>> If you have a bad block anywhere on the degraded drives, you're going to
>> lose data.
>>
> Exactly. A risk I'd like to avoid, of course.

IMO you should definitely go to RAID6 with such large drives, IMO with
a hot spare as well. The recovery process takes *so* long, it's very
likely that a second drive will fail during that vulnerable window and
poof. Use the money you're saving on per-GB costs these days to buy
yourself a bit more redundancy, otherwise what's the point of using
RAID at all eh?

Of course if the data is getting frequently archived to well-tested
backups, or is otherwise easily replace or of little value (e.g. video
collection) then the extra cost might not be worth it to you. Just
don't underestimate the geometric increase in risk by going to bigger
and bigger size drives.
