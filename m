From: Eric Valette <Eric.Valette@Free.fr>
Subject: Problem with array raid10 array resync on 4.4.0 (keeps reyncing each
 reboot)
Date: Tue, 26 Jan 2016 15:49:42 +0100
Message-ID: <56A78786.10103@Free.fr>
Reply-To: <Eric.Valette@Free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

My raid 10 array (5 disk with one spare) was doing a  resync after an 
upgrade to 4.4.0 from 4.1.15. The resync progress was steady and at the 
end the /proc/mdstat was apparently complete but when rebooting, it 
started resycing over and over. I noticed my dmesg was totally filled 
with raid10 conf printout message so it was impossible to trace anything 
else.

Did a resync test with 3.14.58 (because I knew it had worked for resync 
before and was still available as a boot option)  and the array was 
correctly rebuild.
Runs fine with 4.1.16 now.

Please CC me as I'm not subscribed.

-- eric

