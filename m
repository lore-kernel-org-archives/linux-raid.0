From: "Subodh S" <subodh_s_1975@mail.com>
Subject: How to change retry count of lower layer drivers
Date: Mon, 14 Apr 2003 08:44:02 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030414134402.32064.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Whenever the path on which an I/O is in-progress, 
goes down, sd takes a long time to detect it. As per 
my knowledge it would be 60sec * 5(no. of retries) 
plus the time taken by the lower layer driver(hba) 
to detect the failure. Is this correct ?? Is there a 
way available to reduce this "timeout/retry count" 
value without modifying sd.c


-subodh
-- 
__________________________________________________________
Sign-up for your own FREE Personalized E-mail at Mail.com
http://www.mail.com/?sr=signup

