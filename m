From: "Darius S. Naqvi" <dnaqvi@datagardens.com>
Subject: bitmap chunk size
Date: Tue, 10 Nov 2009 09:39:44 -0700 (MST)
Message-ID: <alpine.DEB.1.00.0911100933160.10087@darius>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is there any possibility of having a bitmap chunk size of 512 bytes?
I know that mdadm rejects anything under 4k.  I fear that the
assumption of the 4k minimum is embedded fairly strongly in the code.
Can my fear be alleviated?

-- 
Darius S. Naqvi
dnaqvi@datagardens.com
http://www.datagardens.com
