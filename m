From: Oliver Heinz <oheinz@stud.fbi.fh-darmstadt.de>
Subject: libata + raid
Date: Mon, 24 Nov 2003 18:42:39 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200311241842.39015.oheinz@stud.fbi.fh-darmstadt.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,
after searching the web for a while i still could not find a definitive
statement whether libata does/will support raid modes on it's supported
controllers.

For those controllers which only pretend to be raid controllers and do the
whole magic in their drivers, support of their vendor specific raid would be
more a nifty comfort feature.

But i.e. some promise controllers 2037x seem to have a hardware xor engine
(well my only source of information on that, is a posting from alan cox ;-) .

Libata support seems to be derived from the pdc-ultra-driver which seems to
 be non-raid only unlike the partly closed source par15-driver, right?
When I boot with libata enabled on a pdc20378 in raid-mode I get two
independend drives instead off one raid-array.

Will raid-mode be supported? Is there a way I can help? Or maybe it's just
stupid to complain about missing support on a quite powerful machine (2xXeon
2.6GHz), and I should use software raid anyway?

Does libata (need to?) support hot-plugging?

Sorry for so many questions at once, but there seems to be very little
(uptodate) Information about this on the web - well at least I didn't find
it...

Bye,
Oliver



