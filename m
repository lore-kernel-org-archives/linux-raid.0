From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH 03/18] md: occasionally checkpoint drive recovery to reduce
	duplicate effort after a crash
Date: Thu, 12 Feb 2009 12:26:49 -0500
Message-ID: <18836.23513.23378.858964@stoffel.org>
References: <20090212031009.23983.14496.stgit@notabene.brown>
	<20090212031010.23983.74842.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090212031010.23983.74842.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "NeilBrown" == NeilBrown  <neilb@suse.de> writes:

NeilBrown> '16' is a fairly arbitrary number.  But we don't really
NeilBrown> have any good way to judge how often is acceptable, and it
NeilBrown> seems like a reasonable number for now.

Maybe once an hour as well?  I don't have good numbers here, but just
a feeling that I'd hate to waste more than hour if possible.  But hey,
this is a big improvement no matter what.

John
