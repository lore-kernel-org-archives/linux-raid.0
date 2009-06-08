From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: RE: How to un-degrade an array after a totally spurious failure?
Date: Sun, 7 Jun 2009 22:54:15 -0300
Message-ID: <18988.28487.697258.566987@fisica.ufpr.br>
References: <a2ada9611479c051e268a76df8b45b40.squirrel@neil.brown.name>
	<20090608014354722.FGFJ26412@cdptpa-omta03.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090608014354722.FGFJ26412@cdptpa-omta03.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Leslie Rhorer (lrhorer@satx.rr.com) wrote on 7 June 2009 20:43:
 >OK, what about a RAID 6 array with one failed disk?  Is the remove & add the
 >best option there, or should one apply a different method?

It is, since that's what the raid is for. It's still operational.
We've done it here and it works.
