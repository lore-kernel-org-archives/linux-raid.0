From: Wayne Gemmell <wayne@flashmedia.co.za>
Subject: Online resize
Date: Tue, 11 Mar 2008 11:19:55 +0200
Message-ID: <200803111119.56015.wayne@flashmedia.co.za>
Reply-To: wayne@flashmedia.co.za
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all

I'd like to do an online resize for my RAID5 drives now that I've upgraded 
them to 500GB drives. Now I'm a bit stuck. I assume the steps would be the 
following.

1) Resize partitions
2) Drop EXT3 journal
3) run e2resize
4) Recreate journal.

Are there any raid specific things I have to do to get this to work. Am I on 
the right track?




-- 
Regards
Wayne 
