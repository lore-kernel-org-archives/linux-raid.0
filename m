From: David T-G <davidtg-robot@justpickone.org>
Subject: Re: re-add syntax
Date: Thu, 21 May 2020 14:07:00 -0400
Message-ID: <20200521180700.GT1415@justpickone.org>
References: <20200520200514.GE1415@justpickone.org>
 <5EC5BBEF.7070002@youngman.org.uk>
 <20200520235347.GF1415@justpickone.org>
 <5EC63745.1080602@youngman.org.uk>
 <20200521110139.GW1711@justpickone.org>
 <20200521112421.GK1415@justpickone.org>
 <5EC66D4E.8070708@youngman.org.uk>
 <20200521123306.GO1415@justpickone.org>
 <828a3b59-f79c-a205-3e1e-83e34ae93eac@youngman.org.uk>
 <20200521131500.GP1415@justpickone.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200521131500.GP1415@justpickone.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi, all --

...and then davidtg-robot@justpickone.org said...
% 
% ...and then antlists said...
% % 
% % So *you* should choose re-add. Let mdadm choose add if it can't do a re-add.
% 
% Thanks.  Sooooo ...  Given this
...
% does this
% 
%   mdadm --manage /dev/md0 --re-add /dev/sdd1
% 
% look like the right next step?

Perhaps it did, but it wasn't to be:

  diskfarm:root:10:~> mdadm --manage /dev/md0 --re-add /dev/sdd1
  mdadm: --re-add for /dev/sdd1 to /dev/md0 is not possible

So we'll try "add"

  diskfarm:root:10:~> mdadm --manage /dev/md0 --add /dev/sdd1
  mdadm: added /dev/sdd1

and now we wait :-)


Thanks again to all

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt
