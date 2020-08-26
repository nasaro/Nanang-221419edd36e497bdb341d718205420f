<?php
namespace App\Models;
 
use CodeIgniter\Model;
 
class Login_model extends Model {
 
    protected $table = 'user';
 
    public function getLogin($id = false)
    {
        if($id === false){
            return $this->findAll();
        } else {
            return $this->getWhere(['username' => $id])->getRowArray();
        }  
    }
     
    public function insertLogin($data)
    {
        return $this->db->table($this->table)->insert($data);
    }
 
    public function updateLogin($data, $id)
    {
        return $this->db->table($this->table)->update($data, ['username' => $id]);
    }
 
    public function deleteLogin($id)
    {
        return $this->db->table($this->table)->delete(['username' => $id]);
    }
}
?>