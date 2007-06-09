From: Peter Rabbitson <rabbit@rabbit.us>
Subject: question about --assume-clean
Date: Sat, 09 Jun 2007 19:40:42 +0200
Message-ID: <466AE61A.1000107@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am about to create a large raid10 array, and I know for a fact that 
all the components are identical (dd if=/dev/zero of=/dev/sdXY). Is it 
safe to pass --assume-clean and spare 6 hours of reconstruction, or are 
there some hidden dangers in doing so?

Thanks

Peter
