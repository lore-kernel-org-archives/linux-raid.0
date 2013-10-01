From: Mark Keisler <mark@mitsein.net>
Subject: RAID10 scrub
Date: Tue, 1 Oct 2013 15:42:39 -0500
Message-ID: <CA+FAjA90MPuA4aQUqmKRAzEsxJFMFJ9_UZFeiWJd__QAmS-mBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is scrub (sync) needed on RAID10?  I've noticed in mdadm monitor logs that
it seems to re-allocate data destined for bad blocks on the fly anyway.
 Maybe I don't quite understand what the scrub does, though :)
I ran it for the first time on my RAID last night anyway to make sure all
way well since I am failing out a dying disk for replacement today.
-- 
Mark Keisler
"I have been here. Now I am going there. Where? ... No, I won't have it!"
