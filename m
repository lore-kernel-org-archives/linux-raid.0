From: David T-G <davidtg-robot@justpickone.org>
Subject: re-add syntax (was "Re: failed disks, mapper, and "Invalid
 argument"")
Date: Thu, 21 May 2020 08:33:06 -0400
Message-ID: <20200521123306.GO1415@justpickone.org>
References: <20200520200514.GE1415@justpickone.org>
 <5EC5BBEF.7070002@youngman.org.uk>
 <20200520235347.GF1415@justpickone.org>
 <5EC63745.1080602@youngman.org.uk>
 <20200521110139.GW1711@justpickone.org>
 <20200521112421.GK1415@justpickone.org>
 <5EC66D4E.8070708@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5EC66D4E.8070708@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

...and then Wols Lists said...
% 
% On 21/05/20 12:24, David T-G wrote:
% > Sure enough, there it is.  Yay.
% > 
% > Now ...  What do I do with the last drive?  Can I put it back in and let
% > it catch up, or should it reinitialize and build from scratch?
% 
% Can't remember the syntax, but there's a re-add option. If it can find
% and replay a log of failed updates, it will bring the drive straight
% back in. Otherwise it will rebuild from scratch.
% 
% That's probably the safest way - let mdadm choose the best option.

OK; yay.  I'm still confused, though, between "add" and "readd".  I'll
take any pointers to docs I can get.


% 
% Oh - and when you get your Ironwolves or whatever, read up on the
% replace option. Much the safest option.

THAT sounds familiar.  Thanks.


% 
% Cheers,
% Wol


HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt
