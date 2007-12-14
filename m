From: "Jeff Breidenbach" <jeff@jab.org>
Subject: Re: mdadm break / restore soft mirror
Date: Fri, 14 Dec 2007 11:13:49 -0800
Message-ID: <e03b90ae0712141113r37ab0955w644a3422f8c382a3@mail.gmail.com>
References: <05ED21952E28E94E8352836547A6BA37042318B3@achmsx001.hsa.co.uk>
	 <18272.34965.638276.892803@notabene.brown>
	 <e03b90ae0712122000m439069y8ccad65c59cf4de9@mail.gmail.com>
	 <18272.45576.359862.395170@notabene.brown>
	 <e03b90ae0712132340t61e3bef6x8159e6d24da9c254@mail.gmail.com>
	 <18274.18454.258328.131866@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18274.18454.258328.131866@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Brett Maton <Brett.Maton@simplyhealth.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So the obvious follow up question is: for this scenario does it make sense to
only resync the difference between the two bitmaps? E.g. Drive A will have
a current bitmap, B will have a stale bitmap. Presumably one could get away
with just resyncing the difference.

Or is this too much of special case to consider?

Jeff
