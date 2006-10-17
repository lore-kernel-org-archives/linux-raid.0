From: Olivier Doremieux <olivier@doremieux.org>
Subject: Compile problem
Date: Tue, 17 Oct 2006 17:22:12 +0200
Message-ID: <4534F524.3050806@doremieux.org>
Reply-To: olivier@doremieux.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

When I am trying to compile the 2.5.4 release, I am getting this error :

In file included from util.c:34:
/usr/include/linux/blkpg.h:36: error: variable or field '__user' 
declared void
/usr/include/linux/blkpg.h:36: error: syntax error before '*' token
util.c: In function 'remove_partitions':
util.c:128: error: storage size of 'a' isn't known
cc1: warnings being treated as errors
util.c:128: warning: unused variable 'a'
make: *** [util.o] Error 1

Thanks in advance and thanks for the great work,

Olivier Doremieux
