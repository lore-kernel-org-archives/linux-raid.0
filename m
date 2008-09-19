From: "John Stoffel" <john@stoffel.org>
Subject: Re: Raid6 array crashed-- 4-disk failure...(?)
Date: Fri, 19 Sep 2008 10:55:46 -0400
Message-ID: <18643.48498.606058.710551@stoffel.org>
References: <48CE250C.8000603@ultratux.net>
	<20080915125951.GA17966@skl-net.de>
	<48CE9811.60307@ultratux.net>
	<20080916082509.GA17300@skl-net.de>
	<48CFF1E9.30006@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48CFF1E9.30006@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: Maarten <maarten@ultratux.net>
Cc: Andre Noll <maan@systemlinux.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Maarten" == Maarten  <maarten@ultratux.net> writes:

>> You could use jbod mode (or create single-disk "raid arrays") with
>> Areca or 3ware controllers and use software raid on top of that.

Maarten> True, but then that would kind of defeat the whole purpose of
Maarten> the fairly expensive card. In that case a better investment
Maarten> might be a sort of servergrade motherboard which has 6 good
Maarten> onboard controllers and at least two separate PCI buses for
Maarten> the add-on cards. (For the price of one 12 port Areca you can
Maarten> already buy a bare bones low-range server...).

Maarten> The main selling point of most hardware raid cards is that
Maarten> they seem to be doing a much better job predicting failure of
Maarten> a drive than software raid can. I don't know how they do
Maarten> that, but a fact is I've never even heard of a two-disk
Maarten> failure with hardware raid. Which of course doesn't say it
Maarten> cannot happen, but it does seem to be a lot less likely
Maarten> somehow.

Hah!  I'll trump that.  In a previous job we had a bunch of Netapp
Filers.  Nice boxes, really nice and reliable.  We had a two disk
failure in one volume, so they do happen.

Managed to get it back by swapping the disk driver controller board
between the really failed drive and the second failed drive.  Took
quite a few hours of mucking about, but it was certainly better than
losing the data and doing large restores.

Nowdays Netapp has their double parity Raid6 like setup for data,
since with 1Tb disks,a second failure isn't all that unlikely.

Pretty soon I suspect disk^Wstorage will be cheap enough that we'll
just mirror and snapshot and try NOT to write to offline media if at
all possible.  Except for data which hasn't been accessed recently.

HSM anyone?

John
