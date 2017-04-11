From: Wakko Warner <wakko@animx.eu.org>
Subject: Shrinking an array
Date: Mon, 10 Apr 2017 20:30:08 -0400
Message-ID: <20170411003008.GA18538@animx.eu.org>
Reply-To: Wakko Warner <wakko@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a question about shrinking an array.  My current array is 4x 2tb
disks in raid6 (md0).  The array was created on the 2nd partition of each
disk and spans most of the disk.  I would like to replace the 2tb disks with
750gb disks.  md0 is a luks container with lvm underneath.  I have less than
1tb actually in use.  What would the recommended procedure be for shrinking
this?  I've watched this list, but I don't think I've come across anyone
actually wanting to do this before.
I'm thinking of these steps already:
1) Shrink PV.
2) Shrink luks.  I'm aware that there is not size metadata, but the dm
mapping would need to be shrunk.
3) Shrink md0.  I did this once when I changed a 6 drive raid6 into a 5
drive raid6.  Would I use --array-size= or --size= ?  I understand the
difference is the size of md0 vs the individual members.

So for number 4, if md0 is now small enough, will it accept a member that is
smaller?  If so, I should beable to add the member to the array and issue
--replace.

Thanks.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
