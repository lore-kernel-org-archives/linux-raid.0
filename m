From: Roman Mamedov <rm@romanrm.net>
Subject: Re: assistance recovering failed raid6 array
Date: Mon, 20 Feb 2017 22:50:28 +0500
Message-ID: <20170220225028.59824758@natsu>
References: <58AA4B1E.1030809@bosner.de>
        <e01061cb-ea4c-4f64-16e8-e6027adbc70d@turmel.org>
        <E18A7C79-09E0-4361-9F89-68AE1E6FCBF6@bosner.de>
        <5cc1566c-1b4c-c663-56a1-2040b93b46d7@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5cc1566c-1b4c-c663-56a1-2040b93b46d7@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Bosner <martin@bosner.de>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On 02/20/2017 12:05 PM, Martin Bosner wrote:
> > === START OF INFORMATION SECTION ===
> > Model Family:     Seagate Barracuda 7200.14 (AF)
> > Device Model:     ST3000DM001-1CH166

So you have the most terrible hard drive possible [1][2](they WILL ALL fail),
ran in about the most terrible RAID setup possible (only a single RAID5 would
have been worse). Now you realize why the latter was a bad idea: with such a
great number of disks, should have picked a 3x12-member RAID6 or similar. Just
let this be a lesson in component choice and risk assessment, restore from
your backups and move on.

[1] https://en.wikipedia.org/wiki/ST3000DM001
[2] https://www.quora.com/What-are-some-of-the-worst-hard-drive-designs-ever

-- 
With respect,
Roman
