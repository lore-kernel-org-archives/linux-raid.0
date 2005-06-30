From: Eric Pretorious <eric@pretorious.net>
Subject: RAID1: What happens when one half of a mirror fails?
Date: Thu, 30 Jun 2005 10:24:12 -0700
Message-ID: <200506301024.13126.eric@pretorious.net>
Reply-To: eric@pretorious.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, All:

I've been a bit surprised by the complete failure of our system when one half 
of a mirror failed so I suppose that I should verify that I understand 
RAID1's failover methodology: Is the purpose of the mirror only to preserve 
the data or is it to allow the system to continue operating until a 
replacement can be installed? (i.e., If one half of a mirror fails, shouldn't 
the system continue operating normally?)

-- 
Eric P.,
Truckee, CA
