From: Leslie Rhorer <lesrhorer@att.net>
Subject: mdadm not sending status on check
Date: Fri, 14 Feb 2020 04:01:15 -0600
Message-ID: <82922d71-cc13-dd3b-d75b-0bfa87883252@att.net>
References: <82922d71-cc13-dd3b-d75b-0bfa87883252.ref@att.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

     Ever since upgrading to Debian Buster, mdadm no longer sends out 
status reports during the monthly array test.  I think the test is 
running, but I am not certain.  Go can I check to make sure it is 
configured to run, and if it is, how can I ensure it will send out 
e-mail alerts?  Testing the system with

|mdadm --monitor --scan --||test| |-1|

|    works properly.
|
