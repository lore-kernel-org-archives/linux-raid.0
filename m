From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 13/28] crypto: adapt api sample to -EIOCBQUEUED as backlog indication
Date: Sun,  2 Jul 2017 17:41:55 +0300
Message-ID: <1499006535-19760-14-git-send-email-gilad__28216.38194514$1499006731$gmane$org@benyossef.com>
References: <1499006535-19760-1-git-send-email-gilad@benyossef.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1499006535-19760-1-git-send-email-gilad@benyossef.com>
Sender: linux-raid-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Jonathan Corbet <corbet@lwn.net>, David Howells <dhowells@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, Gary Hook <gary.hook@amd.com>, Boris Brezillon <boris.brezillon@free-electrons.com>, Arnaud Ebalard <arno@natisbad.org>, Matthias Brugger <matthias.bgg@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Steve French <sfrench@samba.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, linux-crypto@v
Cc: Ofir Drang <ofir.drang@arm.com>
List-Id: linux-raid.ids

Replace -EBUSY with -EIOCBQUEUED for backlog queueing indication
as part of new API.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---

This patch should be squashed with the first patch in the series
when applied.

 Documentation/crypto/api-samples.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/crypto/api-samples.rst b/Documentation/crypto/api-samples.rst
index 2531948..c6aa4ba 100644
--- a/Documentation/crypto/api-samples.rst
+++ b/Documentation/crypto/api-samples.rst
@@ -47,7 +47,7 @@ Code Example For Symmetric Key Cipher Operation
         case 0:
             break;
         case -EINPROGRESS:
-        case -EBUSY:
+        case -EIOCBQUEUED:
             rc = wait_for_completion_interruptible(
                 &sk->result.completion);
             if (!rc && !sk->result.err) {
-- 
2.1.4

