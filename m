From: Wakko Warner <wakko@animx.eu.org>
Subject: Drive replace question
Date: Fri, 11 Jul 2014 13:13:38 -0400
Message-ID: <20140711171338.GA7295@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When a drive is being replaced and has lots of errors, does it get kicked
before the resync is completed?

I'm performing this action now on a system with kernel 3.14.6.  I don't
believe the mdadm version makes a difference but it's debian version 3.3-2

Here's the mdstat for that array:
md1 : active raid1 sde[3](R) sdj[2] sdk[1]
      1465138448 blocks super 1.0 [2/2] [UU]
      [>....................]  recovery =  0.0% (419648/1465138448) finish=174.5min speed=139882K/sec
      bitmap: 3/11 pages [12KB], 65536KB chunk

sdj is being replaced by sde.  Currently, md1 is not in use.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
