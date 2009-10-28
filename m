From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: md software raid
Date: Tue, 27 Oct 2009 19:52:56 -0500
Message-ID: <20091028005303577.NTSS9287@cdptpa-omta02.mail.rr.com>
References: <70ed7c3e0910271747o29e53a69l2b88de8d538284aa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0910271747o29e53a69l2b88de8d538284aa@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> Leslie,
> 
> How do you check xfs? xfs_check?

	Yes.

> Why not use xfs_repair -n?

	I guess the short answer is, "I didn't know it would make a
difference".  I take it, then, xfs_repair uses a completely different method
of scanning for errors than xfs_check, one whihcdoes not require so much
memory?  I find that a bit surprising.

