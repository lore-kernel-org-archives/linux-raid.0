From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Raid5/6 journal vs write intent bitmap
Date: Fri, 13 Oct 2017 11:45:48 -0400
Message-ID: <018cfc6e-e133-fb83-b328-3649b9c8ca0f@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I added a write journal to an exiting array that had a write intent 
bitmap. I recall that the bitmap should have been removed automatically 
when I added the journal but I can't find any references to that. The WI 
bitmap was not removed automatically. Perhaps I was mistaken.

Since the array now has a write journal, is it safe to assume that the 
WI bitmap can be removed? I assume that the journal eliminates the need 
for a re-sync after an unclean shutdown since it will replay in-flight 
transactions in order to bring the array back to a consistent state.

--Larkin
