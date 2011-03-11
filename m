From: Justin Maggard <jmaggard10@gmail.com>
Subject: BUG_ON() at shutdown time
Date: Thu, 10 Mar 2011 16:28:45 -0800
Message-ID: <AANLkTi=R5rxqCo3cPYc41bZQXaO-NydBhcYJvh7fLHNT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Now that barriers are supported in MD, would it make sense to revisit
the old bug I posted, outlined at
http://www.spinics.net/lists/raid/msg21821.html?  Dan seemed to
suggest that barrier support may make it possible to fix it properly
at http://marc.info/?l=linux-raid&m=123139948817351&w=2.

Thanks,
-Justin
